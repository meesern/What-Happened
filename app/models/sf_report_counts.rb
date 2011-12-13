
#
# Access the map-reduce collection of report counts
# The collection to retain per second, per minute, per hour, per day
# and per year report counts for each aspect.
#
# This is done as a hierarchical series of map-reduce requests which
# are updated as the database is modified.
#
class SfReportCounts 

  def self.count_map
    # TODO: map-reduce hierarchically (for close to a third less load) 
    # store time as UTC microseconds
    <<-JS
      function(){
        var kdate;
        var time = 0;
        kdate = this.known;
        if (kdate)
          time = kdate.getTime() + kdate.getTimezoneOffset() * 60000;
        mintime = Math.floor(time / 60000) * 60000;
        daytime = Math.floor(time / (60000*60*24)) * (60000*60*24);
        emit({'aspect': this.aspect,'time': time, 'grain':'second'},1);
        emit({'aspect': this.aspect,'time': mintime, 'grain':'minute'},1);
        emit({'aspect': this.aspect,'time': daytime, 'grain':'day'},1);
      }
      JS
  end

  def self.count_reduce
    <<-JS
      function(key, values){
        var count = 0;
        for (i in values) {
          count += values[i];
        }
        return count;
      }
      JS
  end

  #
  #  Create a fresh collection of counts.  This is an expensive query.
  #  Call on power up or after deleting or modifying reports.
  #
  def self.boot
    lastrec = SfReport.last(:order => :created_at.asc)
    self.last = lastrec.created_at
    SfReport.collection.map_reduce(count_map, count_reduce, 
                        :out => 'counts')
  end

  #
  #  Update only newly added reports (since the call to boot)
  #  Call when adding reports to database.
  #
  def self.update
    prev = self.last
    current_last = SfReport.last(:order => :created_at.asc).created_at.to_i * 1000.0
    unless (prev ==  current_last) 
      self.last = current_last
      SfReport.collection.map_reduce(count_map, count_reduce, 
                    :out => {:reduce => 'counts'},
                    :query => {'created_at' => 
                                 {'$gt' => prev, '$lte' => current_last}
      })
    end
  end

  def self.count_between(aspect, grain, from, to )
    from ||= Time.at(0)
    to   ||= Time.now
    #map-reduce had to generate a javascript time in milliseconds
    from = from.to_i * 1000.0 unless from.class == Float
    to = to.to_i * 1000.0 unless to.class == Float
    q = self.counts.find  "_id.aspect" => aspect, 
                       "_id.grain" => grain,
                       "_id.time" => {'$gt' => from, '$lte' => to}
    #return array of hashes with time and value
    q.map{ |c| {'time' => c['_id'].andand['time'], 'count' => c['value'] }}
  end

  #The counts collection 
  def self.counts
    SfReport.database['counts']
  end
  
  #The meta data collection 
  def self.meta
    SfReport.database['meta']
  end

  #
  # Store the last counted record time in the collection
  #
  def self.last=(time)
    #store as a ms javascript time
    time = time.to_i * 1000.0 unless time.class == Float
    self.meta.update( {'_id' => 'Latest_Counted'}, {'_id' => 'Latest_Counted', 'time' => time}, {'upsert' => true} )
  end

  def self.last
    rec = self.meta.find '_id' => 'Latest_Counted'
    rec.to_a[0].andand['time']
  end

end

