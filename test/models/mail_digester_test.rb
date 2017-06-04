# coding: UTF-8

require 'test_helper'

class MailDigesterTest < ActiveSupport::TestCase
  def test_run
    mails = [
      Mail.read( "#{FIXTURES_PATH}/bike_geolocalized.raw_mail" ),
      Mail.read( "#{FIXTURES_PATH}/bike_no_geolocalized.raw_mail" ),
    ]

    Mail.expects( :all ).returns( mails ).once
    
    assert_difference( "Bike.count", 2 ) do
      MailDigester.run
    end
  end

  def test_process_bike_geolocalized_mail
    mail = Mail.read( "#{FIXTURES_PATH}/bike_geolocalized.raw_mail" )

    assert_difference "Bike.count", 1 do
      MailDigester.process( mail )
    end

    bike = Bike.last
    assert_equal( "Fürbringerstraße 25, 10961 Berlin, Germany", bike.address )
    assert_equal( "52.49333333333333, 13.3965", bike.gps )
    assert_equal( true, bike.pic.present? )
    assert_equal( "fguillen.mail@gmail.com", bike.email )
    assert_equal( "2011-10-22 10:31:25", bike.date.to_s(:db) )
  end

  def test_process_bike_no_geolocalized_mail
    mail = Mail.read( "#{FIXTURES_PATH}/bike_geolocalized.raw_mail" )

    assert_difference "Bike.count", 1 do
      MailDigester.process( mail )
    end

    bike = Bike.last
    assert_equal( "Fürbringerstraße 25, 10961 Berlin, Germany", bike.address )
    assert_equal( "52.49333333333333, 13.3965", bike.gps )
    assert_equal( true, bike.pic.present? )
    assert_equal( "fguillen.mail@gmail.com", bike.email )
    assert_equal( "2011-10-22 10:31:25", bike.date.to_s(:db) )
  end
end