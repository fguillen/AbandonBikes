FactoryGirl.define do
  factory :bike do
    sequence( :address ) { |n| "address #{n}" }
    sequence( :gps ) { |n| "#{n},#{n+1}" }
  end
end