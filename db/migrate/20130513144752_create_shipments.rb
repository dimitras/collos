class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :tracking_number
      t.integer :shipper_id
      t.integer :receiver_id
      t.datetime :ship_date
      t.datetime :recieve_date
      t.timestamps
    end
    add_index :shipments, :tracking_number
    add_index :shipments, :shipper_id
    add_index :shipments, :receiver_id
  end
end
