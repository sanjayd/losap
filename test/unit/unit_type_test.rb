require 'test_helper'

class UnitTypeTest < ActiveSupport::TestCase
  test 'names' do
    assert_not_nil(UnitType.find_by_name('Engine'))
    assert_not_nil(UnitType.find_by_name('Truck'))
    assert_not_nil(UnitType.find_by_name('Ambulance'))
  end
end
