require 'mongo_mapper'

class SfReport 
  include MongoMapper::Document

  key  :known,    Time
  key  :second,   Float
  key  :aspect,   Integer
  key  :entity,   Integer
  key  :item,     Integer
  key  :event,    Integer
  key  :measurement, Hash
  timestamps!

  ensure_index [[:aspect, 1], [:known, 1], [:second, 1]]
  ensure_index [[:entity, 1], [:known, 1], [:second, 1]]
  ensure_index [[:item, 1],   [:known, 1], [:second, 1]]

  #many :hobbies

  #validates_true_for :second, :message => "Second must be between 0 and 1",
  #    :logic => lambda { second.nil? || (second >= 0.0 and second < 1.0) }


  scope :start, lambda { |from, to|
     where(:known.gte => from, :known.lt => to)  }

  scope :next, lambda { |from, sec|
     where(:known => from, :second.gt => sec)  }

  def self.aspect_known_inside(aspect, from, to)
    #order and limit to 30,000
    self.where( :aspect => aspect, :known.gte => from, :known.lt => to).limit(30000)
  end

  def self.aspect_all(aspect)
    self.where( :aspect => aspect ).limit(30000)
  end

  def self.aspect_count(aspect)
    self.where( :aspect => aspect ).count
  end

  def self.aspect_first_known(aspect)
    #this is a bit ugly really.  map is require to enumerate the array
    #of one in order to resolve the query.
    self.where(:aspect => aspect).sort(:known).limit(1).map{|r|r}[0]
  end

  def self.aspect_last_known(aspect)
    self.where(:aspect => aspect).sort(:known.desc).limit(1).map{|r|r}[0]
  end

  def self.aspect_count_known_inside(aspect,from,to)
    #would rather do this by map reduce
    self.aspect_known_inside(aspect, from, to).count
  end

  def measurement=(ment)
    unless ment.class == Hash
      if ment.class == String
        begin
          parsed = JSON.parse(ment)
        rescue
          parsed = nil
        end
        if parsed
          if parsed.class == Hash
            ment = parsed
          else
            ment = {:measurement => parsed}
          end
        else
          ment = {:measurement => ment}
        end
      end
    end
    @measurement = ment
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

  #
  # May be needed to keep hobo happy
  #
  def self.has_lifecycle?
    false
  end

end
