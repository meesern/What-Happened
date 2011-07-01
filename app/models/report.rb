#
# requires in environment.rb do not seem to be enough here.
require 'rubygems'
require 'bundler/setup'
require 'pacecar'

class Report < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    known          :datetime
    measurement    :text
    confidence     :float
    timestamps
  end
  
  include Pacecar

  belongs_to :aspect
  belongs_to :clerks_report


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
