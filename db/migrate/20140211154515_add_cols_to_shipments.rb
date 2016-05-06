class AddColsToShipments < ActiveRecord::Migration
  def change
  	add_column :shipments, :past_container, :string
  	add_column :shipments, :new_container, :string
  	add_column :shipments, :complete, :boolean
  end
end
