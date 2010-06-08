class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month
  
  def month=(month)
    write_attribute(:month, month.beginning_of_month)
  end
end
