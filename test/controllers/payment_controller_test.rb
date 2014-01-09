require 'test_helper'

class PaymentControllerTest < ActionController::TestCase
  test "should get main" do
    get :main
    assert_response :success
  end

  test "should get offsite" do
    get :offsite
    assert_response :success
  end

  test "should get onsite" do
    get :onsite
    assert_response :success
  end

  test "should get return" do
    get :return
    assert_response :success
  end

end
