class AddOrigAddressToBike < ActiveRecord::Migration
  def change
    add_column :bikes, :orig_address, :string
    
    Bike.all.each { |e| e.update_attribute( :orig_address, e.address ) }
  end
end
