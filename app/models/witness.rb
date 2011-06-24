class Witness < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  #Witness.primary_key = "api_key"

  fields do
    name        :string
    description :text
    veracity    :text
    character   :text
    api_key     :string
    timestamps
  end

  attr_readonly :api_key

  belongs_to    :user
  has_many      :aspect
  has_many      :clerks_reports

  after_initialize { api_key = "777" }


  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
