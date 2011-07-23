class LockedMonth < ActiveRecord::Base
  validates_uniqueness_of :month, :message => 'is already locked'

  def self.months
    if Date.today.month == 1
      (1 .. 12).map do |month|
        Date.parse("#{Date.today.year - 1}-#{month}-1")
      end.reverse
    else
      (1 .. Date.today.month - 1).map do |month|
        Date.parse("#{Date.today.year}-#{month}-1")
      end.reverse
    end
  end

  def self.locked_months
    rel = nil

    if Date.today.month == 1
      rel = where('month >= ?', (Date.today - 1.year).beginning_of_year)\
            .where('month <= ?', (Date.today - 1.year).end_of_year)
    else
      rel = where('month >= ?', Date.today.beginning_of_year)
    end
    
    rel.order('month desc')
  end
  
  def self.unlocked_months
    self.months - self.locked_months.map {|m| m.month}
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
