class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :line_3
      t.string :city
      t.string :state
      t.string :zip
      t.string :province
      t.string :country

      t.timestamps
    end
  end
end
