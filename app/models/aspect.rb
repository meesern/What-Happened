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

  def sfreports
    SfReport.aspect_all(self.id)
  end

  def sfreport_count
    SfReport.aspect_count(self.id)
  end

  def report_counts(level, t_start, t_end)
    SfReportCounts.update
    t_start  ||= SfReport.aspect_first_known(self.id).andand.known
    t_end    ||= SfReport.aspect_last_known(self.id).andand.known
    counts = []
    #stop if we have no counts
    return counts if t_start.nil?
    #otherwise scan at the requested granularity
    sfcounts = SfReportCounts.count_between(self.id, level.to_s, t_start, t_end)
    sfcounts.each do |sfcount|
        report = Time.at(sfcount['time']/1000.0)
        counts << {:year=>report.year, 
          :day=>report.yday, :minute=>report.hour*60+report.min,
          :second=>report.sec, :count => sfcount['count']}
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
