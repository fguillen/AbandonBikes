class AddOrigAddressToBike < ActiveRecord::Migration[5.1]
  def change
    add_column :bikes, :orig_address, :string

    Bike.all.each { |e| e.update_attribute( :orig_address, e.address ) }
  end
end
