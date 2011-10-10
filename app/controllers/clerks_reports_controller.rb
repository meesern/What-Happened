class ClerksReportsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def file_xml
    file(:xml)
  end

  def file_json
    file(:json)
  end

  def file(encoding)
    logger.info("Data for aspect #{params[:aspect]} is #{params[:data]}")
    aspect = Aspect.find(params[:aspect])
    ClerksReport.file(params[:data], encoding, aspect)
  end

end
