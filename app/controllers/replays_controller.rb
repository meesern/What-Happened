class ReplaysController < ApplicationController
  before_filter :allow_cross_domain_access

  hobo_model_controller

  auto_actions :all, :except=>[:create]

  def control
    hobo_edit do
      @replay.action(params)
      render :text=>"yey\n"
    end
  end

  def create
    hobo_create do
      if @replay.associate(params[:aspect])
        @replay.action(params)
        render :text=>"woo\n"
      else
        render :text=>"invalid aspect\n", :status => 400
      end
    end
  end

  protected

end

