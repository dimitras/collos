class CreateContainersShipments < ActiveRecord::Migration
  def up
    create_table :containers_shipments, id: false do |t|
        t.references :container
        t.references :shipment
    end
    add_index :containers_shipments, :container_id
    add_index :containers_shipments, :shipment_id
  end

  def down
    # remove_index :containers_shipments, :container_id
    # remove_index :containers_shipments, :shipment_id
    drop_table :containers_shipments
  end
end
