class Standby < ActiveRecord::Base
  POINTS = 1

  validates_presence_of :start_time
  validate :no_overlap_with_existing_sleep_in, :no_future_months, :if => "self.start_time"
  validate :start_before_end, :end_before_next_morning, :no_overlap,
           :if => "self.start_time and self.end_time"

  belongs_to :member

  before_validation :add_in_dates

  def deleted?
    self.deleted
  end

  def short?
    if self.end_time
      (self.end_time - self.start_time) < 4.hours
    end
  end

  def date
    self.start_time ? self.start_time.beginning_of_day.to_date : nil
  end

  def points
    if self.end_time
      if self.deleted? || self.short?
        0
      else
        1
      end
    end
  end

  def hours
    if self.end_time.nil?
      nil
    elsif self.deleted? || self.short?
      0
    else
      (self.end_time - self.start_time) / 1.hour
    end
  end

  def start_date
    self.start_time.nil? ? @start_date : self.start_time.to_date
  end

  def start_date=(date)
    date = Date.parse(date)
    if self.start_time.nil?
      @start_date = date
    else
      self.start_time = combine_date_and_time(date, self.start_time)
    end
  end

  def end_date
    self.end_time.nil? ? @end_date : self.end_time.to_date
  end

  def end_date=(date)
    date = Date.parse(date)
    if self.start_time.nil?
      @end_date = date
    else
      self.end_time = combine_date_and_time(date, self.end_time)
    end
  end

  def self.find_by_year(year)
    self.find(:all, 
              :conditions => ["start_time >= ? AND start_time <= ?",
                              year.to_time.beginning_of_year,
                              year.to_time.end_of_year],
              :order => "start_time ASC")
  end

  def self.find_by_month(month)
    self.find(:all,
              :conditions => ["start_time >= ? AND start_time <= ?",
                              month.to_time.beginning_of_month,
                              month.to_time.end_of_month],
              :order => "start_time ASC")
  end

  def self.find_by_date(date)
    date = date.to_date
    self.find(:all,
              :conditions => ["start_time >= ? AND start_time < ? AND deleted = ?",
                              date,
                              date + 1.day,
			      false],
              :order => "start_time ASC")
  end       

  protected
  def start_before_end
    if self.end_time
      unless self.start_time < self.end_time
        errors.add(:end_time, "must be after the start time")
      end
    end
  end

  def end_before_next_morning
    t = self.start_time + 1.day
    unless self.end_time < Time.local(t.year, t.month, t.day, 7, 0, 0)
      errors.add(:end_time, "must be before 0700 on the morning following the start time")
    end
  end

  def no_overlap
    self.member.standbys.find_by_date(self.date).each do |s|
      unless s.end_time.nil? or self == s
        if (s.start_time .. s.end_time).include? self.start_time
          errors.add(:start_time, "cannot overlap with an existing Standby")
        elsif (s.start_time .. s.end_time).include? self.end_time
          errors.add(:end_time, "cannot overlap with an existing Standby")
        elsif (self.start_time .. self.end_time).include? s.end_time
          errors.add(:end_time, "cannot overlap with an existing Standby")
        end
      end
    end
  end
  
  def no_future_months
    if start_time and start_time > Time.now.end_of_month
      errors.add(:start_time, "cannot be in a future month")
    end
  end

  def no_overlap_with_existing_sleep_in
    if self.member.sleep_ins.find_undeleted_by_date(self.start_time.to_date - 1.day)
      if self.start_time < self.start_time.beginning_of_day + 7.hours
        errors.add(:start_time, "cannot overlap with an existing Sleep-In")
      end
    end
    
    if self.member.sleep_ins.find_undeleted_by_date(self.start_time.to_date)
      if self.start_time > self.start_time.beginning_of_day + 19.hours
        errors.add(:start_time, "cannot overlap with an existing Sleep-In")
      elsif self.end_time and self.end_time > self.start_time.beginning_of_day + 19.hours
        errors.add(:end_time, "cannot overlap with an existing Sleep-In")
      end
    end
  end 

  def add_in_dates
    if @start_date
      self.start_time = combine_date_and_time(@start_date,
                                              self.start_time)
    end

    if @end_date
      self.end_time = combine_date_and_time(@end_date,
                                            self.end_time)
    end
  end

  private
  def combine_date_and_time(date, time)
    Time.zone.local(date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.min,
                    time.sec)
  end
end
