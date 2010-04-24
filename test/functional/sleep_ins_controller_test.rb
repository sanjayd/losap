require 'test_helper'

class SleepInsControllerTest < ActionController::TestCase

  def setup
    @m1 = members(:one)
    @m2 = members(:two)
    @one = sleep_ins(:one)
    @two = sleep_ins(:two)
    @three = sleep_ins(:three)
    @four = sleep_ins(:four)
  end

  test 'index' do
    assert_raise(ActionController::RoutingError) {get :index}
    get :index, :member_id => @m1.id
    assert_response :success
    assert_not_nil(assigns(:member))
    assert_equal(@m1, assigns(:member))
    assert_not_nil(assigns(:sleep_ins))
    assert_equal(@m1.sleep_ins.size, assigns(:sleep_ins).size)
    
    @one.member = @m1
    assert @one.save
    @two.member = @m1
    assert @two.save
    get :index, :member_id => @m1.id
    assert_response :success
    assert_not_nil(assigns(:sleep_ins))
    assert_equal(2, assigns(:sleep_ins).size)
    assert_not_nil(assigns(:sleep_ins).find(@one))
    assert_not_nil(assigns(:sleep_ins).find(@two))

    s = SleepIn.new
    s.date = @one.date + 5.days
    s.unit = 'Engine'
    s.member = @m1
    s.save
    get :index, :member_id => @m1.id
    assert_response :success
    assert_not_nil(assigns(:sleep_ins))
    assert_equal(3, assigns(:sleep_ins).size)
    assert assigns(:sleep_ins)[1].date > assigns(:sleep_ins)[0].date
    assert assigns(:sleep_ins)[2].date > assigns(:sleep_ins)[1].date
  end

  test 'new' do
    assert_raise(ActionController::RoutingError) {get :new}
    get :new, :member_id => @m1.id
    assert_response :success
    assert_not_nil(assigns(:member))
    assert_not_nil(assigns(:sleep_in))
    assert_equal(@m1, assigns(:member))
    assert_template('sleep_ins/new')
  end

  test 'create' do
    sleepin_count = SleepIn.count
    post :create, :sleep_in => {:date => Date.today - 1.month,
                                :unit => 'Engine'},
                  :member_id => @m1.id
    assert_not_nil(assigns(:sleep_in))
    assert_redirected_to(@m1)
    assert_equal('Saved Sleep-In', flash[:notice])
    sleepin_count = sleepin_count + 1
    assert_equal(sleepin_count, SleepIn.count)

    assert_raise(ActionController::RoutingError) do
      post :create, :sleep_in => {:date => Date.today - 1.month + 1.day,
                                  :unit => 'Truck'}
    end

    post :create, :sleep_in => {:unit => 'Ambulance'},
                  :member_id => @m1.id
    assert_response :success
    assert_equal(sleepin_count, SleepIn.count)
    assert_template('sleep_ins/new')
  end

  test 'destroy' do
    assert_raise(ActionController::RoutingError) {post :destroy}
    assert_raise(ActionController::RoutingError) {post :destroy, :id => 7}
    
    @m1.sleep_ins << @one
    @m1.sleep_ins << @two
    sleepin_count = SleepIn.count
    assert_equal(2, @m1.sleep_ins.count)

    post :destroy, :id => @one.id, :member_id => @m1.id
    assert_redirected_to(@m1)
    assert_equal(sleepin_count - 1, SleepIn.count)
    assert_raise(ActiveRecord::RecordNotFound) {@one.reload}
  end
end
