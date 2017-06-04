class Bike < ActiveRecord::Base
  scope :geolocalized, -> { where( "gps is not null" ) }

  if Rails.env.production?
    has_attached_file(
      :pic,
      :path => ":id_:style.:extension",
      :url => ":s3_domain_url",
      :storage => :s3,
      :s3_region => APP_CONFIG["s3"]["region"],
      :s3_credentials => APP_CONFIG["s3"]["credentials"],
      :styles => {
        :min => "300x300>"
      }
    )
  else
    has_attached_file(
      :pic,
      :path => ":rails_root/public/attachments/:rails_env/:id_:style.:extension",
      :styles => {
        :min => "300x300>"
      }
    )
  end

  validates_attachment_content_type :pic, :content_type => ["image/jpg", "image/jpeg", "image/png"]


  def lat
    gps.split(',')[0].strip
  end

  def lng
    gps.split(',')[1].strip
  end

  def pic_in_local
    @pic_in_local = Paperclip.io_adapters.for(pic)
  end

  def update_gps
    self.gps =
      Geo.address_to_gps( orig_address ) ||
      Geo.image_to_gps( pic_in_local.path )

    save!
  end

  def update_address
    self.address =
      Geo.address_to_address( orig_address ) ||
      Geo.gps_to_address( gps )

    save!
  end

  def update_date
    self.date = EXIFR::JPEG.new( pic_in_local.path ).date_time

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
