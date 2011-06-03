class AspectsController < ApplicationController

  hobo_model_controller

  auto_actions :all 
  auto_actions_for :reports, [:new, :create]

  def data
    a = Aspect.find params[:aspect]
    render :text => a.report_data
  end

end
