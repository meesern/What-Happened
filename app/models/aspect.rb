class Aspect < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  fields do
    name        :string
    description :text
    pattern     :text
    timestamps
  end

  belongs_to :entity
  has_many   :reports
  has_many   :witnesses


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
