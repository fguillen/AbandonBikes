class Bike < ActiveRecord::Base
  scope :geolocalized, where( "gps is not null" )
  
  has_attached_file(
    :pic, 
    :styles => { 
      :min => "300x300>"
    }
  )
  
  def lat
    gps.split(',')[0].strip
  end
  
  def lng
    gps.split(',')[1].strip
  end
  
  def update_gps
    self.gps ||= 
      Geo.image_to_gps( pic.path ) ||
      Geo.to_gps( address )
      
    save!
  end
  
  def update_address
    self.address ||= Geo.to_address( gps )
    save!
  end
  
  def to_hash
    {
      id:       id,
      address:  address,
      lat:      lat,
      lng:      lng,
      pic:      pic( :url ),
      pic_min:  pic( :min )
    }
  end
    
end
