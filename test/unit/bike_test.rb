require 'test_helper'

class BikeTest < ActiveSupport::TestCase
  def test_update_gps_from_address
    address = 'mi calle, 25, madrid'
    gps     = "gps coordinates"
    bike    = Factory( :bike, :address => address, :gps => nil )
  
    Geo.expects( :image_to_gps ).returns( nil ).once    
    Geo.expects( :to_gps ).with( address ).returns( gps ).once
    
    bike.update_gps
    
    assert_equal( gps, bike.gps )
  end
  
  def test_scope_geolocalized
    bike_1 = Factory( :bike, :gps => 'coordinates' )
    bike_2 = Factory( :bike, :gps => nil )
    
    assert_equal( [bike_1.id], Bike.geolocalized.map(&:id) )
    assert_equal( [bike_1.id, bike_2.id], Bike.all.map(&:id) )
  end
  
  def test_process_pic
    bike = Factory( :bike, :pic => File.new( "#{FIXTURES_PATH}/pic_no_geolocalized.jpg" ) )
    
    assert_equal( true, bike.pic.present? )
    assert_equal( 160513, bike.pic.size )
  end
end