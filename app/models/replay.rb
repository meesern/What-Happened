#
# requires in environment.rb do not seem to be enough here.
require 'rubygems'
require 'bundler/setup'
require 'pacecar'
require 'backgroundrb'

class Replay < ActiveRecord::Base
  hobo_model # Don't put anything above this
  include Pacecar
  after_initialize   :create_node
  before_validation  :default_values
  validates_uniqueness_of :name, :allow_nil=>true
  attr_protected     :running

  fields do
    name        :text 
    rate        :decimal 
    gapskip     :decimal 
    from        :datetime 
    to          :datetime 
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

  def action(params)
    self.start if params[:start]
    self.stop  if params[:stop]
  end

  def start
    unless self.running
      logger.info("starting replay")
      MiddleMan.worker(:xmpp_worker).xmpp_replay_start(self)
      self.running = true
      save!
    end
  end

  def stop
    if self.running
      MiddleMan.worker(:xmpp_worker).xmpp_replay_stop(self)
      self.running = false
      save!
    end
  end

  # The action point for creating replays 
  
  #
  # self is newly created but not saved
  #
  def create_node
    logger.info("create_node #{self.id} id ")
    MiddleMan.worker(:xmpp_worker).xmpp_create_node(self)
  end

end
