class Report < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    known_from     :datetime
    known_until    :datetime
    measurement    :text
    confidence     :float
    made_by        :integer
    timestamps
  end

  belongs_to :aspect


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
