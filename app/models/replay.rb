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
    self.rate    = params[:rate]
    self.gapskip = params[:gapskip]
    self.from    = params[:from]
    self.to      = params[:to]
    self.name    = params[:replayid]
    self.start if params[:start]
    self.stop  if params[:stop]
    save! if self.changed?
  end

  def start
    unless self.running
      logger.info("starting replay")
      self.running = true
      save!
      MiddleMan.worker(:xmpp_worker).xmpp_replay_start(:arg=>self.id)
    end
  end

  def stop
    if self.running
      MiddleMan.worker(:xmpp_worker).xmpp_replay_stop(:arg=>self.id)
      self.running = false
      save!
    end
  end

  def node
    xmlurl(self)
  end

  # The action point for creating replays 
  
  #
  # self is newly created but not saved
  #
  def create_node
    username = RUBBER_CONFIG.app_name
    server = RUBBER_CONFIG.domain
    path = "/home/#{server}/#{username}/#{self.node}"
    logger.info("create_node #{path}")
    MiddleMan.worker(:xmpp_worker).xmpp_create_node(:arg=>path)
    path
  end

end
