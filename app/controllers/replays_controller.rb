class ReplaysController < ApplicationController
  before_filter :allow_cross_domain_access

  hobo_model_controller

  auto_actions :all, :except=>[:create]

  def control
    hobo_edit do
      @replay.action(params)
      render :text=>"yey"
    end
  end

  def create
    hobo_create do
      @replay.action(params)
      render :text=>"woo"
    end
  end

  protected

end

