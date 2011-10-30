require 'test_helper'

class BikeTest < ActiveSupport::TestCase
  def test_update_gps_from_orig_address
    orig_address  = 'mi calle, 25, madrid'
    gps           = "gps coordinates"
    bike          = Factory( :bike, :orig_address => orig_address, :gps => nil )

    Geo.expects( :image_to_gps ).never
    Geo.expects( :address_to_gps ).with( orig_address ).returns( gps ).once

    bike.update_gps

    assert_equal( gps, bike.gps )
  end
  
  def test_update_gps_from_pic
    gps           = "gps coordinates"
    bike          = Factory( :bike, :orig_address => nil, :gps => nil )

    Geo.expects( :image_to_gps ).with( bike.pic.path ).returns( gps ).once

    bike.update_gps

    assert_equal( gps, bike.gps )
  end
  
  def test_update_address_from_orig_address
    orig_address  = 'mi calle, 25, madrid'
    address       = "final address"
    bike          = Factory( :bike, :orig_address => orig_address, :gps => nil )

    Geo.expects( :gps_to_address ).never
    Geo.expects( :address_to_address ).with( orig_address ).returns( address ).once

    bike.update_address

    assert_equal( address, bike.address )
  end
  
  def test_update_address_from_gps
    gps           = "gps coordinates"
    address       = "final address"
    bike          = Factory( :bike, :orig_address => nil, :gps => gps )

    Geo.expects( :gps_to_address ).with( gps ).returns( address ).once

    bike.update_address

    assert_equal( address, bike.address )
  end
  
  def test_update_date_from_image
    bike = Factory( :bike, pic: File.new( "#{FIXTURES_PATH}/pic_geolocalized.jpg" ) )
    
    bike.update_date
    
    assert_equal( "2011-10-22 10:31:25", bike.date.to_s(:db) )
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
    bike = 
      Factory( 
        :bike, 
        address:  "my address",
        gps:      "1, 2",
        pic:      File.new( "#{FIXTURES_PATH}/pic_geolocalized.jpg" ),
        date:     Time.parse( "2001-01-01 10:11:12" )
      )

    assert_equal( bike.id               , bike.to_hash[:id] )
    assert_equal( "my address"          , bike.to_hash[:address] )
    assert_equal( "1"                   , bike.to_hash[:lat] )
    assert_equal( "2"                   , bike.to_hash[:lng] )
    assert_equal( bike.pic( :original ) , bike.to_hash[:pic] )
    assert_equal( bike.pic( :min )      , bike.to_hash[:pic_min] )
    assert_equal( "2001-01-01 09:11:12" , bike.to_hash[:date] )
  end
end
