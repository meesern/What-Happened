#
# requires in environment.rb do not seem to be enough here.
require 'rubygems'
require 'bundler/setup'
require 'pacecar'

class ClerksReport < ActiveRecord::Base
  hobo_model # Don't put anything above this
  include Pacecar


  fields do
    witness :integer
    aspect  :integer
    submitted_records   :decimal
    accepted_records    :decimal
    status  :text
    timestamps
  end

  has_many :reports

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

  # The action point for storing data.  Here is where a witness reports on an
  # aspect.  It is the job of the clerk's report to validate, parse and store
  # the reported data in the model
  # TODO  Consider the responses - what happens when the data is not accepted
  # etc.
  # Caller must identify the witness and aspect that is being reported on.
  # The report itself is in the form of a self describing blob structured to 
  # contain one or more reports
  #
  # Initially we will be very liberal - tell us it and we will believe you
  # almost without question.  
  #

  def self.recent_report_for(witness, aspect)
    #use the same Clerks Report if there is a recent one.
    #NOTE May not be the most efficeient way of getting a recent report
    self.updated_after(20.seconds.ago).witness_equals(witness).aspect_equals(aspect).last  || self.new
  end

  def self.file( html, aspect )
    #TODO witness is bogus for now
    witness = 0

    #Get a clerks report
    cr = self.recent_report_for(witness, aspect)

    cr.work(:witness=> witness,
            :aspect=> aspect,
            :blob=>   html )

    cr.save! if cr.changed?
  end

  def work( params )
    print "."
    self.witness = params[:witness]
    self.aspect = params[:aspect]
    #ignore witness for now
    # Exception of not found....
    asp = Aspect.find(aspect)
    blob = params[:blob]
    #blob is constrained to be xml but Hpricot will parse just about anything
    #without choking
    doc = Hpricot(blob)
    #pp doc #uncomment to print doc for debug
    #look for <t>'s which indicate time based measurement
    tstamps = doc.search("//t")
    self.submitted_records = (submitted_records || 0) + tstamps.length
    tstamps.each do |ts|
      m = ts.next_sibling
      # TODO This is better done by validating against a schema
      if (m.pathname == "ment")
        time = Time.parse(ts.inner_text)
        rep = asp.reports.find_by_known(time) 
        #update or create a new record
        rep = rep || Report.new( :aspect => asp, :known => time )
        rep.measurement = m.inner_html
        rep.clerks_report = self  #update if udating the record
        rep.save!
        #deal with nul instead of zero in first instance
        self.accepted_records = (accepted_records || 0 ) + 1
      end
    end

  end

end
