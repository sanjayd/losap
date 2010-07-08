require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "role_name" do
    r = Role.new(:name => "role_name")
    assert(r.save, "Failed to save role")
    
    r = Role.new(:name => "role_name")
    assert(!r.save, "Saved duplicate role")
    assert_not_nil(r.errors[:name])
    
    r = Role.new
    assert(!r.save, "Saved role without name")
  end
end
