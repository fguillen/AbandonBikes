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

  def test_to_hash
    bike = Factory( :bike, pic: File.new( "#{FIXTURES_PATH}/pic_geolocalized.jpg" ) )

    assert_equal( bike.id               , bike.to_hash[:id] )
    assert_equal( bike.address          , bike.to_hash[:address] )
    assert_equal( bike.lat              , bike.to_hash[:lat] )
    assert_equal( bike.lng              , bike.to_hash[:lng] )
    assert_equal( bike.pic( :original ) , bike.to_hash[:pic] )
    assert_equal( bike.pic( :min )      , bike.to_hash[:pic_min] )
  end
end
