
DEV_ERRORS = true

#
# Handle all API requests
#
class ApiController < ApplicationController
  before_filter :allow_cross_domain_access

  #File an xml report
  def file_xml
    file(:xml)
  end

  #File a json report
  def file_json
    file(:json)
  end

  #Fetch report data in xml
  def data_xml
    data(:xml)
  end

  #Fetch report data in json
  def data_json
    data(:json)
  end

  #
  # Return the counts profile for an aspect
  #
  def counts_xml
    counts(:xml)
  end

  def counts_json
    counts(:json)
  end

  
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

  # Store a property
  def file_entity_property
    begin
      entity = Entity.find(params[:id])
      file_property(entity.item, entity)
    rescue 
      api_excp($!.message)
    end
  end

  def file_item_property
    begin
      item = Entity.find(params[:id])
      file_property(item, nil)
    rescue 
      api_excp($!.message)
    end
  end

  def query()
    render :text => "Will implement soon."
  end

  protected

  def api_excp(msg)
      raise $! if DEV_ERRORS
      api_error(msg)
  end

  def api_error(msg)
      render :status => 400, :text => msg
  end

  def file_property(item, entity)
    data = JSON.parse(params[:data]).with_indifferent_access 
    data[:entity] = entity.andand.id
    data[:item] = item.andand.id
    begin
      prop = SfProperty.store(data)
      render :text => "_id: #{prop._id.to_s}"
    rescue
      api_excp($!.message)
    end
  end

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

  #
  # Return the report data for an aspect
  #
    def data(encoding)
    a = Aspect.find params[:aspect]
    from,to = spanify(params[:from], params[:until])
    data =  a.report_data(from,to)
    if encoding == :xml
      c = data.map { |r| 
        r.xml
      }
      resp = "<report>\n#{c}</report>\n"
    else
      c = data.map { |r|
        r.json
      }
      resp = JSON.generate(c)
    end
    render :text => resp
  end

  #
  # Return counts for aspect
  #
  def counts(encoding)
    @aspect = Aspect.find params[:aspect]
    from = params[:from]
    to = params[:until]
    from,to = spanify(from,to) unless from.nil? and to.nil?
    level = params[:grain]
    at_least = params[:grain].to_i
    #This is a bit hacky but implement at_least by starting at the highest grain
    #and working down.  Better than doing it in the client at least
    begin
      case 
      when params[:minute] || level == 'second'
        #Day of year is 1..366 in params
        from,to = minutespan( 
                    params[:year], params[:day].to_i-1, params[:minute]) if from.nil?
        counts = counts_in_history(:minute, from, to)
        level = 'stop'
      when params[:day] || level == 'minute'
        #Day of year is 1..366 in params
        from,to = dayspan(params[:year], params[:day].to_i-1) if from.nil?
        counts = counts_in_history(:day, from, to)
        level = 'second'
      when params[:year] || level == 'day'
        from,to = yearspan(params[:year]) if from.nil?
        counts = counts_in_history(:year, from, to)
        level = 'minute'
      else
        counts = counts_in_history(:history, nil, nil)
        from,to = spanify(from,to)
        level = 'day'
      end
    end while counts.length < at_least && level != 'stop'

    if (encoding == :json)
      prepare_json_counts(counts)
    else
      prepare_xml_counts(counts)
    end
  end

  def counts_in_history(level, from, to)
    @aspect.report_counts(level, from, to)
  end

  def prepare_json_counts(data)
    render :text => JSON.generate(data)
  end

  def prepare_xml_counts(data)
    c = data.map do |point| 
      %Q(<count year='#{point[:year]}' \
         #{("day='"+point[:day].to_s+"'") if point[:day]} \
         #{("minute='"+point[:minute].to_s+"'") if point[:minute]} \
         #{("second='"+point[:second].to_s+"'") if point[:second]} \
         >#{point[:count]}</count>\n)
    end
    xml = "<counts>\n#{c.to_s.squeeze(' ')}</counts>\n"
    render :text => xml
  end

  def file(encoding)
    logger.info("Data for aspect #{params[:aspect]} is #{params[:data]}")
    aspect = Aspect.find(params[:aspect])
    ClerksReport.file(params[:data], encoding, aspect)
    render :text => "Data Received"
  end

end
