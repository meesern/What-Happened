include ApplicationHelper
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
    c = self.reports.paginate(:page=>1, :per_page=>10000)
  end

  def report_counts(level, t_start, t_end)
    t_start  ||= self.reports.by_known.first.known
    t_end    ||= self.reports.by_known.last.known
    counts = []
    case level
    when :history
      (t_start.year..t_end.year).each do |year|
        from,to = yearspan(year)
        count = self.reports.known_inside(from,to).length
        counts << {:year=>year, :count=>count} unless count.zero?
      end
    when :year
      time_iterate(t_start,t_end,1.day) do |time, idx|
        count = self.reports.known_inside(time,time+1.day).length
        counts << {:year=>t_start.year, 
                   :day=>idx+1, 
                   :count=>count} unless count.zero?
      end
    when :day
      time_iterate(t_start,t_end,1.minute) do |time, idx|
        count = self.reports.known_inside(time,time+1.minute).length
        counts << {:year=>t_start.year, 
                   :day=>t_start.yday, 
                   :minute=>idx, 
                   :count=>count} unless count.zero?
      end
    when :minute
      time_iterate(t_start,t_end,1.second) do |time, idx|
        count = self.reports.known_inside(time,time+1.second).length
        counts << {:year=>t_start.year, 
                   :day=>t_start.yday, 
                   :minute=>t_start.hour*60+t_start.min, 
                   :second=>idx, 
                   :count=>count} unless count.zero?
      end
    end
    counts
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
