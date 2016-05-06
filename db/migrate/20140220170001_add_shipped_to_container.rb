class AddShippedToContainer < ActiveRecord::Migration
  def change
  	add_column :container_types, :shipped, :boolean
  end
end
