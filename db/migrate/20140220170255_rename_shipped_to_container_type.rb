class RenameShippedToContainerType < ActiveRecord::Migration
  def change
  	rename_column :container_types, :shipped, :shipable
  end
end
