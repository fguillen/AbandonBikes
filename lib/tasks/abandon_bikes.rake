namespace :abandon_bikes do  
  
  desc 'Fetch the emails and create bikes'
  task :mail_fetch => :environment do 
    puts "#{Time.now().to_s(:db)} mail fetching"
    MailDigester.run
    puts "#{Time.now().to_s(:db)} END mail fetching"
    puts ""
  end

end