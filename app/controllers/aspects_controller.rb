class AspectsController < ApplicationController

  before_filter :allow_cross_domain_access

  hobo_model_controller

  auto_actions :all 
  auto_actions_for :reports, [:new, :create]

  def show
    hobo_show do
      @reports = this.reports.paginate(:page => params[:page])
    end
  end

  #
  # Return the report data for an aspect
  #
  def data
    a = Aspect.find params[:aspect]
    from,to = spanify(params[:from], params[:until])
    data =  a.report_data(from,to)
    c = data.map { |r| 
      r.xml
    }
    xml = "<report>\n#{c}</report>\n"
    render :text => xml
  end

  #
  # Return the counts profile for an aspect
  #
  def counts
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

    prepare_counts(counts)
  end

  #def thing
  #  render :json => @object
  #end
  #
  #def thing
  #  render :xml => @object
  #end

  protected

  def counts_in_history(level, from, to)
    @aspect.report_counts(level, from, to)
  end

  def prepare_counts(data)
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

end
