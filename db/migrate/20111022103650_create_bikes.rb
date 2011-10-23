class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
      t.string :address
      t.datetime :date
      t.integer :pic_id
      t.string :email
      t.string :gps

      t.timestamps
    end
  end
end
