require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  
  setup :activate_authlogic
  
  def setup
    AdminSession.create(admins(:one))
    admins(:one).roles << roles(:membership)
    
    @one = members(:one)
    @two = members(:two)
    @three = members(:three)
  end

  test "index" do
    get :index, {:term => '503'}
    assert_response :success
    assert_template('members/index')

    get :index, {:term => '501'}
    assert_response :success
    assert_template('members/index')
  end

  test "show" do
    assert_raise(ActiveRecord::RecordNotFound) {get :show, :id => 7}
    get :show, :id => @one.id
    assert_response :success
    assert_template('members/show')

    d = Date.today - 1.month

    get :show, :id => @one.id, :year => d.year, :month => d.month
    assert_response :success
    assert_template('members/show')
  end

  test "new" do
    get :new
    assert_response :success
    assert_not_nil(assigns(:member))
    assert(assigns(:member).new_record?)
    assert_template('members/new')
  end

  test "create valid member" do
    post :create, :member => {:firstname => 'bobby',
                              :lastname => 'tables',
                              :badgeno => '123456'}
    assert_redirected_to(admin_console_path)
    assert_equal(flash[:notice], 'Member was successfully created.')
  end

  test "create invalid member" do
    post :create, :member => {:firstname => 'lenny',
                              :lastname => 'bruce'}
    assert_response :success
    assert_template('members/new')
  end

  test "edit" do
    assert_raise(ActiveRecord::RecordNotFound) {get :edit, :id => 7}
    get :edit, :id => @one.id
    assert_response :success
    assert_not_nil(assigns(:member))
    assert_equal(@one.id, assigns(:member).id)
    assert_template('members/edit')
  end

  test "update" do
    assert_raise(ActiveRecord::RecordNotFound) {post :update, :id => 7}
    member_count = Member.count
    post :update, {:id => @one.id,
                   :member => {:firstname => @one.firstname,
                               :lastname => 'gupta',
                               :badgeno => @one.badgeno}}
    assert_not_nil(assigns(:member))
    assert_redirected_to(admin_console_path)
    assert_equal(flash[:notice], 'Member was successfully updated.')
    assert_equal(member_count, Member.count)
    @one.reload
    assert_equal('gupta', @one.lastname)
  end

  test "destroy" do
    assert_raise(ActiveRecord::RecordNotFound) {post :destroy, :id => 7}
    member_count = Member.count
    post :destroy, :id => @one.id, format: :json
    assert_response :success
    assert_equal(member_count - 1, Member.count)
    assert_raise(ActiveRecord::RecordNotFound) {@one.reload}
  end
end
