class AddRetiredToContainerTypes < ActiveRecord::Migration
  def up
    add_column :container_types, :retired, :boolean, default: false
  end
  def down
    remove_column :container_types, :retired
  end
end
