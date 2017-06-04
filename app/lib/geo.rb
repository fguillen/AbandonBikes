module Geo
  def self.address_to_gps( address )
    return nil if address.blank?

    geo = Geokit::Geocoders::GoogleGeocoder.geocode( address )

    return geo.success? ? "#{geo.lat}, #{geo.lng}" : nil
  end

  def self.address_to_address( address )
    return nil if address.blank?

    geo = Geokit::Geocoders::GoogleGeocoder.geocode( address )

    return geo.success? ? geo.full_address : nil
  end

  def self.gps_to_address( gps )
    return nil if gps.blank?

    geo = Geokit::Geocoders::GoogleGeocoder.do_reverse_geocode( gps )

    return geo.success? ? geo.full_address : nil
  end

  def self.image_to_gps( file_path )
    gps = EXIFR::JPEG.new( file_path ).gps
    gps ? "#{gps.latitude}, #{gps.longitude}" : nil
  end
end