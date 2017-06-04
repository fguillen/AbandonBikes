# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

bike =
  Bike.create!(
    address:  "Furbringerstrasse, 25, Berlin",
    pic:      File.new( "#{File.dirname(__FILE__)}/../test/fixtures/pic_geolocalized.jpg" )
  )

bike.update_gps
bike.update_address
bike.update_date


bike =
  Bike.create!(
    address:  "Furbringerstrasse, 1, Berlin",
    pic:      File.new( "#{File.dirname(__FILE__)}/../test/fixtures/pic_geolocalized.jpg" )
  )

bike.update_gps
bike.update_address
bike.update_date