require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test "username" do
    ad = Admin.new(:username => "a_username",
      :password => "password",
      :password_confirmation => "password")
    assert(ad.save, ad.errors.inspect)
    
    ad = Admin.new(:username => "a_username",
      :password => "password",
      :password_confirmation => "password")
    assert(!ad.save, "Saved an admin with duplicate username")
        
    ad = Admin.find_by_username("a_username")
    ad.roles << roles(:superuser)

    assert(ad.has_role?("superuser"))
  end
end
