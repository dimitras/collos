class ModifyContainer < ActiveRecord::Migration
  def change
	rename_column :containers, :label, :name
  	remove_column :containers, :ancestry_id
  end
end
