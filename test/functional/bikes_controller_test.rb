require 'test_helper'

class BikesControllerTest < ActionController::TestCase
  def setup
  end

  def test_index
    Bike.any_instance.stubs( :to_hash ).returns( "bike_json" )

    2.times { Factory( :bike ) }

    get :index

    assert_response :success
    assert_equal( "application/json", @response.content_type )
    assert_equal( ["bike_json", "bike_json"], JSON.parse( @response.body ) )
  end

  def test_show
    Bike.any_instance.stubs( :to_hash ).returns( "bike_json" )

    bike = Factory( :bike )

    get :show, id: bike.id

    assert_response :success
    assert_equal( "application/json", @response.content_type )
    assert_equal( "bike_json", @response.body )
  end
end
