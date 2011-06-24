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
  has_many   :clerks_reports

  def tree
    self.attributes.except "created_at","updated_at","item_id"
  end


  def report_data
    #Limit 20 first 10000 to prevent timeout
    #TODO implement paging in the API
    c = self.reports.paginate(:page=>1, :per_page=>1000)
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
