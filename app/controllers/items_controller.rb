class ItemsController < ApplicationController

  hobo_model_controller
  before_filter :allow_cross_domain_access

  auto_actions :all

  # Get current item tree for api
  def apiindex_xml
    #TODO authentication
    tree = Item.tree
    xml = XmlSimple.xml_out({'items'=>tree}, 
                            "RootName"=>'itemtree', 
                            'NoAttr'=>true, 
                            'SuppressEmpty'=>nil)
    txtresponse(xml)
  end

  # Get current item tree for api
  def apiindex_json
    tree = Item.tree
    json = JSON.generate(tree)
    txtresponse(json)
  end
  
  # Create an item tree 
  def apicreate_json
    apicreate(:json)
  end

  # Create an item tree 
  def apicreate_xml
    apicreate(:xml)
  end

  protected
  # Create an item tree 
  # @param[Symbol] encoding :json or :xml
  def apicreate(encoding)
    #TODO authentication
    logger.info("Creation data for item #{params[:id]} is #{params[:data]}")
    @item = Item.find params[:id]
    if @item.nil?
      render :text => "Error: item with id #{params[:id]} not found."
    else
      if (encoding == :json)
        #Find out what we know.
        struct = JSON.parse(params[:data]).with_indifferent_access
      else
        struct = XmlSimple.xml_in(params[:data])
      end
      #Validate
      render :text => @error_message unless valid(struct)
      #Create structure
      tree = self.tree_create(struct)

      if (encoding == :json)
        resp = JSON.generate(tree)
      else
        resp = XmlSimple.xml_out(tree, 
                            "RootName"=>'entitytree', 
                            'NoAttr'=>true, 
                            'SuppressEmpty'=>nil)
      end
      txtresponse(resp)
    end
  end

  def txtresponse(txt)
    logger.info "responding with #{txt}"
    render :text => txt
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
      me = @item.entities.find(e['id']) unless e['id'].nil?
      me ||= @item.entities.find_by_name(e['name'])
      me ||= @item.entities.build(:name=>e['name'])
      if me.changed?
        me.save! 
        me.reload #get our new id
      end
      #return any new id
      struct['entities'][i]['id'] = me.id

      j = 0
      e['aspects'].each do |a|
        ma = nil
        ma = me.aspects.find(a['id']) unless a['id'].nil?
        ma ||= me.aspects.find_by_name(a['name']) 
        ma ||= me.aspects.build(:name=>a['name'])
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
