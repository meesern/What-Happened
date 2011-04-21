class AspectsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  auto_actions_for :reports, [:new, :create]

end
