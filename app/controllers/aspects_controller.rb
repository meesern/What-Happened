class AspectsController < ApplicationController

  before_filter :allow_cross_domain_access

  hobo_model_controller

  auto_actions :all 
  auto_actions_for :reports, [:new, :create]

  def index
    hobo_index do
      @wibble = 1
    end
  end

  def show
    hobo_show do
      @reports = this.reports.paginate(:page => params[:page])
      @sfreports = this.sfreports.paginate(:page => params[:page])
    end
  end


end
