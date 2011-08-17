class SleepIn < ActiveRecord::Base
  HOURS = 12
  POINTS = 1

  attr_accessible :date, :unit, :member_id, :deleted

  validates_presence_of :date, :unit
  validates_uniqueness_of :date, :scope => :member_id, 
                          :message => " can only have one Sleep-In"
  validate :unlocked, :no_future_months, :no_overlap_with_existing_standby

  belongs_to :unit_type
  belongs_to :member

  after_initialize :init

  scope :by_year,
    lambda { |year|
      where('date >= ?', year.to_date.beginning_of_year)\
      .where('date <= ?', year.to_date.end_of_year)\
      .order('date asc')
    }
  
  scope :by_month, 
    lambda { |month|
      where('date >= ?', month.to_date.beginning_of_month)\
      .where('date <= ?', month.to_date.end_of_month)\
      .order('date asc')
    }

  def init
    self.date ||= Date.today
  end

  def hours
    self.deleted? ? 0 : HOURS
  end

  def points
    self.deleted? ? 0 : POINTS
  end

  def deleted?
    self.deleted
  end

  def locked?
    self.date and LockedMonth.find_by_month(self.date.beginning_of_month)
  end

  def unit
    unit_type.nil? ? nil : self.unit_type.name
  end

  def unit=(unit_name)
    self.unit_type = UnitType.find_by_name(unit_name)
  end

  def self.find_undeleted_by_date(date)
    self.find_by_date(date,
                      :conditions => ["deleted = ?", false])
  end

  private
  def unlocked
    if self.date and self.locked?
      errors.add(:date, 'cannot be in a locked month')
    end
  end
  
  def no_future_months
    if date and date > Date.today.end_of_month
      errors.add(:date, "cannot be in future months")
    end
  end

  def no_overlap_with_existing_standby
    if member and date
      self.member.standbys.find_by_date(date).each do |sb|
        if sb.end_time > date + 19.hours
          errors.add(:date, "cannot overlap with existing Standby")
        end
      end

      self.member.standbys.find_by_date(date + 1.day).each do |sb|
        if sb.start_time < date + 1.day + 7.hours
          errors.add(:date, "cannot overlap with existing Standby")
        end
      end
    end
  end
end
