class Item < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    description :text
    pattern     :text
    timestamps
  end

  belongs_to :user
  has_many   :entities
  has_many   :properties


  def self.tree
    items = self.find :all
    items.map{ |item| item.tree }
  end

  def tree
    branch = self.attributes.except "created_at","updated_at"
    branch.merge({"entities" => self.entities.map{ |e| e.tree }})
  end


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
