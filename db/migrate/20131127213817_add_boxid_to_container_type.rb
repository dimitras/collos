class AddBoxidToContainerType < ActiveRecord::Migration
  def change
  	add_column :container_types, :box_id, :integer
  end
end
