module MailDigester
  def self.run
    Mail.all.each do |mail|
      puts "XXX: processing mail: #{mail.subject}"
      MailDigester.process( mail )
    end
  end
  
  def self.process( mail )
    bike = 
      Bike.create!(
        :orig_address => mail.subject,
        :pic          => extract_pic( mail ),
        :email        => mail.from.first
      )
      
    bike.update_gps
    bike.update_address
    bike.update_date
  end
  
  def self.extract_pic( mail )
    pic = nil
    
    if( !mail.attachments.empty? )
      attach  = mail.attachments.first
      pic     = StringIO.new( attach.read )
      pic.original_filename = attach.filename
      pic.content_type      = attach.mime_type
    end
    
    pic
  end
end