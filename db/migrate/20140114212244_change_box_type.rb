class ChangeBoxType < ActiveRecord::Migration
  def change
  	rename_column :box_types, :label, :name
  	remove_column :box_types, :freezer_id
  end
end
