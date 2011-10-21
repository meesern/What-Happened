#
# requires in environment.rb do not seem to be enough here.
require 'rubygems'
require 'bundler/setup'
require 'pacecar'
require 'sf_report'

class ClerksReport < ActiveRecord::Base
  hobo_model # Don't put anything above this
  include Pacecar

  fields do
    submitted_records   :decimal
    accepted_records    :decimal
    witness_id          :integer  #need to be explicit for pacecar
    aspect_id           :integer 
    status  :text
    timestamps
  end

  has_many   :reports
  belongs_to    :aspect
  belongs_to    :witness

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
    #NOTE May not be the most efficient way of getting a recent report
    self.updated_after(20.seconds.ago).witness_id_equals(witness).aspect_id_equals(aspect).last  || self.new
  end


  # files a report submitted by html.
  #
  # @param [string] html the report from the client
  # @param [symbol] encoding the format type, `:json` or `:xml`
  # @param [activerecord] aspect the aspect being reported on.
  #
  def self.file( html, encoding, aspect )
    #TODO witness is bogus for now
    witness = Witness.find :first

    #Get a clerks report
    cr = self.recent_report_for(witness, aspect)

    cr.work(:witness=> witness,
            :encoding => encoding,
            :aspect=> aspect,
            :blob=>   html )

    cr.save! if cr.changed?
  end

  # Parse the reported blob for XML measurement.  The blob can contain
  # an arbitrary number of measurements.
  # @param [String] blob the input to be parsed
  def parse_xml(blob)
    #blob is constrained to be xml but Hpricot will parse just about 
    #anything without choking
    doc = Hpricot(blob)
    ments = doc.search("//ment")
    self.submitted_records = (submitted_records || 0) + ments.length
    ments.each do |m|
      save_measurement(m, m.inner_html)
    end
  end

  # Parse the reported blob for JSON measurement.  The blob can contain
  # an arbitrary number of measurements.
  # @param [String] blob the input to be parsed
  def parse_json(blob)
    #parse the JSON to a hash that does not care if we access keys
    #as symbols or strings
    struct = JSON.parse(blob)
    self.submitted_records = (submitted_records || 0) + struct.length
    struct.each { |m|
      save_measurement(m.with_indifferent_access)
    }
  end

  # Take a measurement and save it
  # @param [Hash] m the outer layer containing :t and :s
  # @param [Hash] filling the client provided measurement
  def save_measurement(m)
      time = Time.parse(m[:t])
      second = m[:s].to_f
      #Do not update existing records but rather add a new one unless it
      #is a complete duplicate
      rep = SfReport.new( :aspect => aspect_id, :known => time, :second => second )
      rep.measurement = m[:ment]

      rep.event = self.id  #update if updating the record
      #Avoid duplicates at the expense of a non indexed lookup for each record
      print "#{@dbg_count+=1}-" 
      dup = find_existing(rep.known, rep.second, rep.measurement) unless witness.andand.append_only
      print 'x' unless dup.empty?
      rep.save! if dup.empty?
      #deal with nul instead of zero in first instance
      self.accepted_records = (accepted_records || 0 ) + 1
  end

  # Do the work of filing a clerks report.
  #
  # @param [hash] params the parameters passed by the class method 'file'
  #
  #
  def work( params )
    print "."
    @dbg_count = 0
    self.witness = params[:witness]
    self.aspect = params[:aspect]
    #ignore witness for now
    # Exception of not found....
    if params[:encoding] == :xml
      parse_xml(params[:blob])
    else
      parse_json(params[:blob])
    end
  end

  # Find an existing report (if the record is updatable).  By default
  # this is not called as it lowers the throughput.
  #
  # @param [Date] time the time of the filed report
  # @param [Float] second the fraction of a second of the report (0..1)
  # @param [val] val the value of the recorded measurement
  # @return[Report] the matching report if one exists.
  #
  def find_existing(time, second, val)
    return []
    #TODO find existing in Mongo not SQL
      aspect.reports.find(:all, :conditions=>
           ["known = :k and second = :s and measurement = :m", 
           {:k=>time, :s=> second, :m=>val}])
  end

end
