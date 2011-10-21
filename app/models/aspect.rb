include ApplicationHelper

class Aspect < ActiveRecord::Base
  hobo_model # Don't put anything above this

  MAX_RETURN = 10000
  
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


  def report_data(from, to)
    c = SfReport.aspect_known_inside(self.id, from, to)
  end

  #Better if DRYer
  def report_counts(level, t_start, t_end)
    t_start  ||= SfReport.aspect_first_known(self.id).andand.known
    t_end    ||= SfReport.aspect_last_known(self.id).andand.known
    counts = []
    #stop if we have no counts
    return counts if t_start.nil?
    #otherwise scan at the requested granularity
    case level
    when :history
      (t_start.year..t_end.year).each do |year|
        from,to = yearspan(year)
        count = SfReport.aspect_count_known_inside(self.id, from, to)
        counts << {:year=>year, :count=>count} unless count.zero?
      end
    when :year
      this_block = SfReport.aspect_known_inside(self.id, t_start, t_end)
      counts = []
      count = {}
      last_div = nil
      this_block.each do |report|
        this_div = report.known.yday
        if (this_div != last_div)
          counts << count unless count.empty?
          count = {:year=>report.known.year, 
            :day=>this_div, :count => 1}
          last_div = this_div
        else
          count[:count] += 1
        end
      end
      counts << count unless count.empty?
    when :day
      this_day = SfReport.aspect_known_inside(self.id, t_start, t_end)
      counts = []
      count = {}
      last_minute = nil
      this_day.each do |report|
        this_minute = report.known.hour*60+report.known.min
        if (this_minute != last_minute)
          counts << count unless count.empty?
          count = {:year=>report.known.year, 
            :day=>report.known.yday, :minute=>this_minute, :count => 1}
          last_minute = this_minute
          break if (counts.length >= MAX_RETURN)
        else
          count[:count] += 1
        end
      end
      counts << count unless count.empty?
    when :minute
      this_minute = SfReport.aspect_known_inside(self.id, t_start, t_end)
      counts = []
      count = {}
      last_second = nil
      this_minute.each do |report|
        this_second = report.known.sec
        if (this_second != last_second)
          counts << count unless count.empty?
          count = {:year=>report.known.year, 
            :day=>report.known.yday, :minute=>report.known.hour*60+report.known.min,
            :second=>this_second, :count => 1}
          last_second = this_second
          break if (counts.length >= MAX_RETURN)
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

  def destroy
    #TODO destroy associated reports
  end

  #get the first report in time sequence up until fin
  def first(start, fin)
    start ||= Time.at(0)
    fin   ||= Time.now
    self.reports.start(start,fin).first
  end

  #get the next report following current in time sequence up until fin
  def next(from, sec, fin)
    from ||= Time.at(0)
    sec  ||= 0
    fin  ||= Time.now
    #after is after or equal
    nxt = self.reports.next(from, sec).first
    # or it's the fist from the next second
    nxt ||= self.first(from+1, fin) 
  end

end
