class AddOrigAddressToBike < ActiveRecord::Migration
  def change
    add_column :bikes, :orig_address, :string
  end
end
