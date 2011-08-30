class ReplaysController < ApplicationController
  before_filter :allow_cross_domain_access

  hobo_model_controller

  auto_actions :all, :except=>[:create]

  def control
    logger.info("Replay Control")
    @replay = Replay.find params[:replay]
    logger.info("Updating #{@replay}")
    @replay.action(params)
    render :text=>"Success\n"
  end

  def create
    hobo_create do
      if @replay.associate(params[:aspect])
        @replay.action(params)
        path = @replay.create_node
        render :text=> path
      else
        render :text=>"invalid aspect\n", :status => 400
      end
    end
  end

  protected

end

