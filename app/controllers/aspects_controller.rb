class AspectsController < ApplicationController

  hobo_model_controller

  auto_actions :all 
  auto_actions_for :reports, [:new, :create]

  def show
    hobo_show do
      @reports = this.reports.paginate(:page => params[:page])
    end
  end

  def data
    a = Aspect.find params[:aspect]
    data =  a.report_data
    c = data.map { |r| 
      "<t>#{r.known}</t><ment>#{r.measurement}</ment>" 
    }
    xml = "<report>#{c}</report>"
    render :text => xml
  end

  #def thing
  #  render :json => @object
  #end
  #
  #def thing
  #  render :xml => @object
  #end

end
