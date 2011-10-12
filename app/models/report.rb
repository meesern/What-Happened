#
# requires in environment.rb do not seem to be enough here.
require 'rubygems'
require 'bundler/setup'
require 'pacecar'

class Report < ActiveRecord::Base

  hobo_model # Don't put anything above this

  validates_numericality_of :second, :allow_nil => true, 
      :greater_than_or_equal_to => 0.0, :less_than => 1.0

  fields do
    known          :datetime
    second         :float, :default => 0.0
    measurement    :text
    confidence     :float
    timestamps
  end
  
  include Pacecar

  belongs_to :aspect
  belongs_to :clerks_report

  named_scope :start, lambda { |from, to|
    {:order => "known, second",
     :conditions => ["known >= :k and known < :t",
     {:k => from, :t => to}]}
  }

  named_scope :next, lambda { |from, sec|
    {:order => "known, second",
     :conditions => ["known = :k and second > :s",
     {:s => sec, :k => from}]}
  }


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

  def xml
    message = self.measurement
    message = message[1..-2] if message[0] == ?"
    "<ment t='#{self.known}' s='#{self.second}'>#{message}</ment>" 
  end

  def json
    message = self.measurement
    message = message[1..-2] if message[0] == ?"
    { :t => self.known, :s => self.second, :ment => message }
  end

  #The floating point second difference in time until 'later' report
  def delta(later)
    t1_msb = self.known
    t1_lsb = self.second || 0.0
    t2_msb = later.known
    t2_lsb = later.second || 0.0

    d_msb = t2_msb - t1_msb
    d_lsb = t2_lsb - t1_lsb

    (d_msb + d_lsb)/1.0
  end

end
