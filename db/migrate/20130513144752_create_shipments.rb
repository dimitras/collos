class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :barcode_string
      t.string :tracking_number
      t.integer :shipper_id
      t.integer :receiver_id
      t.datetime :ship_date
      t.datetime :recieve_date
      t.string :tags, limit: 500
      t.string :notes, limit: 500
      t.timestamps
    end
    add_index :shipments, :tracking_number
    add_index :shipments, :shipper_id
    add_index :shipments, :receiver_id
  end
end
