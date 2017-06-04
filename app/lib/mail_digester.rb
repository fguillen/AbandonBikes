module MailDigester
  def self.run
    Mail.all.each do |mail|
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
      attachment  = mail.attachments.first

      pic = StringIO.new(attachment.decoded)
      pic.class.class_eval { attr_accessor :original_filename, :content_type }
      pic.original_filename = attachment.filename
      pic.content_type = attachment.mime_type
    end

    pic
  end
end