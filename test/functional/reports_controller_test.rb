require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  
  setup :activate_authlogic
  
  def setup
    AdminSession.create(admins(:one))

    @one = members(:one)
    @two = members(:two)
  end

  test 'show' do
    assert_raise(ActionController::RoutingError) {get :show}
    get :show, :month => '2009-1-1'
    assert_response :success
    assert_not_nil(assigns(:members))
    assert_not_nil(assigns(:month))
    assert_equal(Date.parse('2009-1-1'), assigns(:month))
  end
end
