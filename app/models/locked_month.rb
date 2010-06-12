class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.last_two_years
    self.find(:all,
      :select => 'month',
      :conditions => ["month >= ?", 2.years.ago.to_date],
      :order => 'month DESC').map {|month| month.month}
  end
  
  def self.locked?(month)
    self.find_by_month(month.beginning_of_month)
  end
  
  def month=(month)
    write_attribute(:month, month.beginning_of_month)
  end
end
