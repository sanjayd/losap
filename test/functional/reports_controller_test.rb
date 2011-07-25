require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  
  setup :activate_authlogic
  
  def setup
    AdminSession.create(admins(:one))
    admins(:one).roles << roles(:reports)

    @one = members(:one)
    @two = members(:two)
  end

  test 'show' do
    assert_raise(ActionController::RoutingError) {get :show}
    get :show, :date => '2009-7-1', :format => "js"
    assert_response :success, @response.body
    assert_not_nil(assigns(:report))
    assert(assigns(:report).monthly?, "Non-monthly report given")
    assert_equal(Date.parse('2009-7-1'), assigns(:report).month)
    
    get :show, :date => "2009"
    assert_response :success, @response.body
    assert_not_nil(assigns(:report))
    assert(assigns(:report).annual?, "Non-annual report given.")
    assert_equal(Date.parse('2009-1-1'), assigns(:report).year)
  end
end
