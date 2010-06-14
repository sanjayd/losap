class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.oldest_month
    oldest_sleep_in = SleepIn.oldest
    oldest_standby = Standby.oldest
    
    if oldest_sleep_in.nil? and oldest_standby.nil?
      nil
    elsif oldest_sleep_in.nil?
      oldest_standby
    elsif oldest_standby.nil?
      oldest_sleep_in
    else
      [oldest_sleep_in.date, oldest_standby.date].min.beginning_of_month
    end
  end

  def self.last_two_years
    months = []
    oldest_month = self.oldest_month

    if oldest_month
      (1 .. 24).each do |num_months|
        month = Date.today.beginning_of_month - num_months.months
        break if oldest_month > month
        months << month
      end
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
