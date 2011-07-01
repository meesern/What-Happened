class AspectsController < ApplicationController

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
    data =  a.report_data
    c = data.map { |r| 
      "<t>#{r.known}</t><ment>#{r.measurement}</ment>" 
    }
    xml = "<report>\n#{c}</report>\n"
    render :text => xml
  end

  #
  # Return the counts profile for an aspect
  #
  def counts
    @aspect = Aspect.find params[:aspect]
    case 
    when params[:minute]
      #Day of year is 1..366 in params
      from,to = minutespan(params[:year], params[:day].to_i-1, params[:minute])
      counts_in_history(:minute, from, to)
    when params[:day]
      #Day of year is 1..366 in params
      from,to = dayspan(params[:year], params[:day].to_i-1)
      counts_in_history(:day, from, to)
    when params[:year]
      from,to = yearspan(params[:year])
      counts_in_history(:year, from, to)
    else
      counts_in_history(:history, nil, nil)
    end
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
    data =  @aspect.report_counts(level, from, to)
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
