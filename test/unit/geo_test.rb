require 'test_helper'

class GeoTest < ActiveSupport::TestCase
  def test_image_to_gps
    gps = Geo.image_to_gps( "#{FIXTURES_PATH}/pic_geolocalized.jpg" )
    assert_equal( "52.49333333333333, 13.3965", gps )
  end
  
  def test_image_to_gps_with_no_geolocalized_image
    gps = Geo.image_to_gps( "#{FIXTURES_PATH}/pic_no_geolocalized.jpg" )
    assert_equal( nil, gps )
  end
end
