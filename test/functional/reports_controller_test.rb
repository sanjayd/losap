require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  def setup
    @one = members(:one)
    @two = members(:two)
  end

  test 'show' do
    assert_raise(ActionController::RoutingError) {post :show}
    assert_raise(ActionController::RoutingError) {post :show, :year => '2009'}
    post :show, :year => '2009', :month => '1'
    assert_response :success
    assert_not_nil(assigns(:members))
    assert_not_nil(assigns(:month))
    assert_equal(Date.parse('2009-1-1'), assigns(:month))
  end
end
