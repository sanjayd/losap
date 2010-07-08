require 'test_helper'

class LockedMonthsControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  
  setup :activate_authlogic

  def setup
    AdminSession.create(admins(:one))
    admins(:one).roles << roles(:reports)
  end
  
  test 'create' do
    locked_months_count = LockedMonth.count
    post :create, :locked_month => {:month => Date.parse('2010-3-1')}
    assert_redirected_to admin_console_path
    assert_equal locked_months_count + 1, LockedMonth.count
    
    post :create, :locked_month => {:month => Date.parse('2010-3-1')}
    assert_redirected_to admin_console_path
    assert_equal locked_months_count + 1, LockedMonth.count
  end
  
  test 'destroy' do
    month = LockedMonth.new(:month => Date.parse('2010-3-1'))
    assert month.save
    
    locked_months_count = LockedMonth.count
    post :destroy, :id => month.id
    assert_redirected_to admin_console_path
    assert_not_nil flash[:notice]
    assert_equal locked_months_count - 1, LockedMonth.count
    assert_raise(ActiveRecord::RecordNotFound) do
      LockedMonth.find(month.id)
    end
  end
end
