module MailDigester
  def self.run
    Mail.all.each do |mail|
      puts "XXX: processing mail: #{mail.subject}"
      MailDigester.process( mail )
    end
  end
  
  def self.process( mail )
    pic = nil
    if( !mail.attachments.empty? )
      attach  = mail.attachments.first
      pic     = StringIO.new( attach.read )
      pic.original_filename = attach.filename
      pic.content_type      = attach.mime_type
    end
    
    bike = 
      Bike.create!(
        :address => mail.subject,
        :pic     => pic,
        :email   => mail.from.first
      )
      
    bike.update_gps
    bike.update_address
  end
end