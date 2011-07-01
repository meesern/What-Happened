# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def yearspan(year)
    [Time.utc(year), Time.utc(year.to_i+1)-1]
  end

  #
  # Day of Year is 0..365 here
  #
  def dayspan(year, dayofyear)
    from = Time.utc(year)+dayofyear.to_i.days
    [from, (from + 1.day)-1]
  end

  def hourspan(year, dayofyear, hourofday)
    from = Time.utc(year)+ dayofyear.to_i.days + hourofday.to_i.hours
    [from, (from + 1.hour)-1]
  end

  def minutespan(year, dayofyear, minuteofday)
    from = Time.utc(year)+ dayofyear.to_i.days + minuteofday.to_i.minutes
    [from, (from + 1.minute)-1]
  end

  def time_iterate(start_time, end_time, step)
    idx = 0
    begin
      yield(start_time, idx)
      idx+=1
    end while (start_time += step) <= end_time
  end
end
