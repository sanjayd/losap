class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.last_two_years
    self.find(:all,
      :select => 'month',
      :conditions => ["month >= ?", 2.years.ago.to_date],
      :order => 'month DESC').map {|month| month.month}
  end

  def self.oldest_month
    [SleepIn.oldest.date, Standby.oldest.date].min.beginning_of_month
  end

  def self.unlocked_in_last_two_years
    months = []
    
    (1 .. 24).each do |num_months|
      month = Date.today.beginning_of_month - num_months.months
      break if self.oldest_month > month
      months << month
    end
    
    months - self.last_two_years
  end

  def self.locked?(month)
    self.find_by_month(month.beginning_of_month)
  end
  
  def month=(month)
    write_attribute(:month, month.beginning_of_month)
  end
end
