module Geo
  def self.to_gps( address )
    return nil if address.blank?
    
    geo = Geokit::Geocoders::GoogleGeocoder.geocode( address )
    
    "#{geo.lat}, #{geo.lng}"
  end
  
  def self.to_address( gps )
    "implement this"
  end
  
  def self.image_to_gps( file_path )
    gps = EXIFR::JPEG.new( file_path ).gps
    gps ? "#{gps.latitude}, #{gps.longitude}" : nil
  end
end