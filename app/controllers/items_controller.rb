class ItemsController < ApplicationController

  hobo_model_controller
  before_filter :allow_cross_domain_access, :only=>[:apiindex, :apicreate]

  auto_actions :all

  # Get current item tree for api
  def apiindex
    #TODO authentication
    tree = Item.tree
    xml = XmlSimple.xml_out({'items'=>tree}, 
                            "RootName"=>'itemtree', 
                            'NoAttr'=>true, 
                            'SuppressEmpty'=>nil)
    xmlresponse(xml)
  end

  
  #
  # Create an item tree 
  def apicreate
    #TODO authentication
    logger.info("Creation data for item #{params[:id]} is #{params[:data]}")
    @item = Item.find params[:id]
    if @item.nil?
      render :text => "Error: item with id #{params[:id]} not found."
    else
      #Find out what we know.
      #All members of struct are arrays (do not use ForceArray = false)
      struct = XmlSimple.xml_in(params[:data])
      #Valdate
      render :text => @error_message unless valid(struct)
      #Create structure
      tree = self.tree_create(struct)

      xml = XmlSimple.xml_out(tree, 
                            "RootName"=>'entitytree', 
                            'NoAttr'=>true, 
                            'SuppressEmpty'=>nil)
      xmlresponse(xml)
    end
  end

  protected
  def xmlresponse(xml)
    logger.info "responding with #{xml}"
    render :text => xml
  end

  def valid(struct)
    valid = true
    struct['entities'].each do |e|
      if e['id'].nil? && e['name'].empty?
        @error_message = "Entities must have a name or id."
        valid = false
        break
      else
        e['aspects'].each do |a|
          if a['id'].nil? && a['name'].empty?
            @error_message = "Aspects must have a name or id."
            valid = false
            break
          end
        end
      end
    end
    valid
  end

  def tree_create(struct)
    i = 0
    struct['entities'].each do |e|
      me = nil
      me = @item.entities.find(e['id'][0]) unless e['id'].nil?
      me ||= @item.entities.find_by_name(e['name'][0])
      me ||= @item.entities.build(:name=>e['name'][0])
      if me.changed?
        me.save! 
        me.reload #get our new id
      end
      #return any new id
      struct['entities'][i]['id'] = me.id

      j = 0
      e['aspects'].each do |a|
        ma = nil
        ma = me.aspects.find(a['id'][0]) unless a['id'].nil?
        ma ||= me.aspects.find_by_name(a['name'][0]) 
        ma ||= me.aspects.build(:name=>a['name'][0])
        if ma.changed?
          ma.save! 
          ma.reload #get our new id
        end
        #return any new id
        struct['entities'][i]['aspects'][j]['id'] = ma.id
        j+=1
      end
      i+=1
    end
    struct
  end
end
