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
    self.gps =
      Geo.address_to_gps( orig_address ) ||
      Geo.image_to_gps( pic.path )

    save!
  end

  def update_address
    self.address =
      Geo.address_to_address( orig_address ) ||
      Geo.gps_to_address( gps )

    save!
  end

  def update_date
    self.date = EXIFR::JPEG.new( pic.path ).date_time

    save!
  end

  def to_hash
    {
      id:       id,
      address:  address,
      lat:      lat,
      lng:      lng,
      pic:      pic( :original ),
      pic_min:  pic( :min ),
      date:     date.to_s(:db)
    }
  end

end
