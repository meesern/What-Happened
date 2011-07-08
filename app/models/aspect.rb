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

  #Better if DRYer
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
      this_block = self.reports.known_inside(t_start,t_end).by_known(:asc)
      counts = []
      count = {}
      last_div = nil
      this_block.each do |report|
        this_div = report.known.yday
        if (this_div != last_div)
          counts << count unless count.empty?
          count = {:year=>t_start.year, 
            :day=>this_div, :count => 1}
          last_div = this_div
        else
          count[:count] += 1
        end
      end
      counts << count unless count.empty?
    when :day
      this_day = self.reports.known_inside(t_start,t_end).by_known(:asc)
      counts = []
      count = {}
      last_minute = nil
      this_day.each do |report|
        this_minute = report.known.hour*60+report.known.min
        if (this_minute != last_minute)
          counts << count unless count.empty?
          count = {:year=>t_start.year, 
            :day=>t_start.yday, :minute=>this_minute, :count => 1}
          last_minute = this_minute
        else
          count[:count] += 1
        end
      end
      counts << count unless count.empty?
    when :minute
      this_minute = self.reports.known_inside(t_start,t_end).by_known(:asc)
      counts = []
      count = {}
      last_second = nil
      this_minute.each do |report|
        this_second = report.known.sec
        if (this_second != last_second)
          counts << count unless count.empty?
          count = {:year=>t_start.year, 
            :day=>t_start.yday, :minute=>report.known.hour*60+report.known.min,
            :second=>this_second, :count => 1}
          last_second = this_second
        else
          count[:count] += 1
        end
      end
      counts << count unless count.empty?
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
