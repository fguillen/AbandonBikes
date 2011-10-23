require 'test_helper'

class MailDigesterTest < ActiveSupport::TestCase
  def test_run
    raw_mails = [
      read_fixture( "bike_geolocalized.raw_mail" ),
      read_fixture( "bike_no_geolocalized.raw_mail" ),
    ]

    assert_difference( "Bike.count", 2 ) do
      FibberMailman.lie_to_me( raw_mails ) do
        MailDigester.run
      end
    end
  end

  def test_process_bike_geolocalized_mail
    mail = Mail.new( "#{FIXTURES_PATH}/bike_geolocalized.raw_mail" )

    assert_difference "Bike.count", 1 do
      MailDigester.process( mail )
    end

    bike = Bike.last
    assert_equal( "implement this", bike.address )
    assert_equal( "52.49333333333333, 13.3965", bike.gps )
    assert_equal( true, bike.pic.present? )
    assert_equal( "fguillen.mail@gmail.com", bike.email )
    assert_equal( nil, bike.date )
  end

  def test_process_bike_no_geolocalized_mail
    mail = Mail.new( "#{FIXTURES_PATH}/bike_geolocalized.raw_mail" )

    assert_difference "Bike.count", 1 do
      MailDigester.process( mail )
    end

    bike = Bike.last
    assert_equal( "Ackerstrasse, 14, berlin", bike.address )
    assert_equal( "52.53107, 13.39782", bike.gps )
    assert_equal( true, bike.pic.present? )
    assert_equal( "fguillen.mail@gmail.com", bike.email )
    assert_equal( nil, bike.date )
  end
end