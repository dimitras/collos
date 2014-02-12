class AddContainerIdsToShipment < ActiveRecord::Migration
  def change
  	add_column :shipments, :past_container_id, :integer
  	add_column :shipments, :new_container_id, :integer
  end
end
