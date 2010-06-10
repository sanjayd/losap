class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.last_two_years
    self.find(:all, :conditions => ["month >= ?", 2.years.ago.to_date])
  end
  
  def month=(month)
    write_attribute(:month, month.beginning_of_month)
  end
end
