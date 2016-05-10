# frozen_string_literal: true

module DateAndTimeParser

  def parse_date(date_string, default_date = nil)
    date_string.to_s.split('/', -1).last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue default_date
  end

  def parse_date_to_s(date_string, default_date = '')
    parse_date(date_string, default_date).strftime("%m/%d/%Y") rescue default_date
  end

  def parse_time(time_string, default_time = nil)
    time_string.to_s.split(':', -1).last.size > 0 ? Time.strptime(time_string, "%H:%M:%S") : Time.strptime(time_string, "%H:%M:") rescue default_time
  end

  def parse_time_to_s(time_string, default_time = '')
    parse_time(time_string, default_time).strftime("%H:%M:%S") rescue default_time
  end

  def parse_integer(string, default_integer = nil)
    begin
      Integer("%g" % string)
    rescue
      default_integer
    end
  end

end
