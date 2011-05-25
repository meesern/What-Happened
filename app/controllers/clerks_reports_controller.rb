class ClerksReportsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def file
    logger.info("Data for aspect #{params[:aspect]} is #{params[:data]}")
    aspect = Aspect.find(params[:aspect])
    ClerksReport.file(params[:data], aspect)
  end

end
