#
# requires in environment.rb do not seem to be enough here.
require 'rubygems'
require 'bundler/setup'
require 'pacecar'
require 'backgroundrb'

class Replay < ActiveRecord::Base
  hobo_model # Don't put anything above this
  include Pacecar
  before_validation  :default_values
  validates_uniqueness_of :name, :allow_nil=>true
  validates_format_of     :name, :with=>/\A\w*\z/, :allow_nil=>true
  validates_associated :aspect
  attr_protected     [:running, :playhead]

  fields do
    name        :text 
    rate        :decimal 
    gapskip     :decimal 
    from        :datetime 
    to          :datetime 
    playhead    :datetime
    running     :boolean 
    playtime    :datetime 
    timestamps
  end

  belongs_to    :aspect
  belongs_to    :report

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

  ###################
  
  def default_values
    self.playtime ||= Time.now
    self.rate ||= 1
    self.gapskip ||= 0
    self.running ||= false
  end

  def associate(asp)
    begin
      self.aspect = Aspect.find(asp)
      save!
    rescue
    end
    self.aspect
  end

  def action(params)
    self.rate    ||= params[:rate] || 1
    self.gapskip ||= params[:gapskip] || 0
    self.from    ||= params[:from] || Time.at(0)
    #do not default 'to' because it can extend beyond now
    self.to      ||= params[:to]
    self.name    ||= params[:replayid]
    self.start if params[:start]
    self.stop  if params[:stop]
    save! if self.changed?
  end

  def start
    unless self.running
      logger.info("starting replay")
      self.running = true
      if first_step()
        save!
        MiddleMan.worker(:xmpp_worker).async_xmpp_replay_start(:arg=>self.id)
      else
        logger.info("no data")
      end
    end
  end

  def stop
    if self.running
      MiddleMan.worker(:xmpp_worker).async_xmpp_replay_stop(:arg=>self.id)
      self.running = false
      save!
    end
  end

  def node
    username = RUBBER_CONFIG.app_name
    server = RUBBER_CONFIG.full_domain
    "/home/#{server}/#{username}/#{xmlurl(self)}"
  end

  # The action point for creating replays 
  
  #
  # self is newly created but not saved
  #
  def create_node
    logger.info("create_node #{self.node}")
    MiddleMan.worker(:xmpp_worker).async_xmpp_create_node(:arg=>self.node)
    self.node
  end

  def first_step
    self.report = self.aspect.first(self.from, self.to)
    save!
    logger.info("f_s current = #{self.report}")
    self.report
  end

  def next_step
    logger.info("n_s current = #{self.report}")
    start,fin = spanify(self.report.known,self.to)
    
    #get the next report in the time period
    self.report = self.aspect.next(self.report.known, self.report.second, self.to)
    save!
    return -1 unless self.report
    future_report = self.aspect.next(self.report.known, self.report.second, self.to)
    return -1 unless future_report

    yield(self.report.xml)
    
    delay = self.report.delta(future_report) 
    r = self.rate
    r = 1 if r.zero?
    delay = delay / r 
    delay = self.gapskip if (self.gapskip > 0 && delay > self.gapskip)
    [delay,0.01].max
  end

end
