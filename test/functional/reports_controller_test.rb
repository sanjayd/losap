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

  test 'show monthly' do
    get :show, :date => '2009-7-1', :format => "js"
    assert_response :success, @response.body
  end
  
  test 'show annual' do
    get :show, :date => "2009"
    assert_response :success, @response.body
  end
end
