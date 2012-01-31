# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
%w(Engine Truck Ambulance).each do |s|
  UnitType.create(:name => s)
end

if Date.today.month == 1
  # Lock all months in previous year
  (1 .. 12).each do |month|
    LockedMonth.create(:month => Date.parse("#{Date.today.year - 1}-#{month}-1"))
  end
else
  # Lock months in current year prior to current month
  (1 .. Date.today.month - 1).each do |month|
    LockedMonth.create(:month => Date.parse("#{Date.today.year}-#{month}-1"))
  end
end

# Add initial roles
%w(superuser reports membership).each do |role_name|
  Role.create(:name => role_name)
end

# Add an initial admin 'sanjayd' with password 'password'
Admin.create(:username => 'sanjayd',
             :password => "password",
             :password_confirmation => "password").roles << Role.find_by_name('superuser')
