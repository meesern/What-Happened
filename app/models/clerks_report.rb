class ClerksReport < ActiveRecord::Base

  hobo_model # Don't put anything above this

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

  def self.file( html )
    cr = self.new
    #TODO these parameters are bogus for now
    cr.work(:witness=> 0,
             :aspect=> Aspect.find_by_name("Hat Location").id,
             :blob=> html )
    cr.save! unless cr.reports.empty?
  end

  def work( params )
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
    submitted_records = tstamps.length
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
        print "."
        #deal with nul instead of zero in first instance
        accepted_records = (accepted_records || 0 ) + 1
      end
    end

  end

end
