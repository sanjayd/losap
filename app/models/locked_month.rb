class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.last_six_months
    months = []

    (1 .. 6).each do |num_months|
      months << Date.today.beginning_of_month - num_months.months
    end

    months
  end

  def self.locked_in_last_six_months
    self.find(:all,
      :select => 'month, id',
      :conditions => ["month >= ?", 7.months.ago.to_date],
      :order => 'month DESC')
  end    

  def self.unlocked_in_last_six_months
    locked = self.locked_in_last_six_months.map {|m| m.month}
    self.last_six_months - locked
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
