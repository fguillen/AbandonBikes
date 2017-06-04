class CreateBikes < ActiveRecord::Migration[5.1]
  def change
    create_table :bikes do |t|
      t.string :address
      t.datetime :date
      t.string :email
      t.string :gps

      t.timestamps
    end
  end
end
