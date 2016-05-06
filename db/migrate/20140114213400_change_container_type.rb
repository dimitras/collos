class ChangeContainerType < ActiveRecord::Migration
  def change
  	remove_column :container_types, :box_id
  	remove_column :container_types, :x_coord_labels
  	remove_column :container_types, :y_coord_labels
  end
end
