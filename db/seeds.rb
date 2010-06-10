# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Add unit types
%w(Engine Truck Ambulance).each do |s|
  UnitType.create(:name => s)
end

# Lock months in current year prior to current month
(1 .. Date.today.month - 1).each do |month|
  LockedMonth.create(:month => Date.parse("#{Date.today.year}-#{month}-1"))
end