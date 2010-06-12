class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.oldest_month
    [SleepIn.oldest.date, Standby.oldest.date].min.beginning_of_month
  end

  def self.last_two_years
    months = []
    
    (1 .. 24).each do |num_months|
      month = Date.today.beginning_of_month - num_months.months
      break if self.oldest_month > month
      months << month
    end

    months
  end

  def self.locked_in_last_two_years
    self.find(:all,
      :select => 'month, id',
      :conditions => ["month >= ?", 2.years.ago.to_date],
      :order => 'month DESC')
  end    

  def self.unlocked_in_last_two_years
    locked = self.locked_in_last_two_years.map {|m| m.month}
    self.last_two_years - locked
  end

  def self.locked?(month)
    self.find_by_month(month.beginning_of_month)
  end
  
  def month=(month)
    unless month.respond_to? :beginning_of_month
      month = Date.parse(month)
    end
    
    write_attribute(:month, month.beginning_of_month)
  end
end
