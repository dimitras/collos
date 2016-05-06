class ChangeContainer < ActiveRecord::Migration
  def change
  	rename_column :containers, :name, :label
  	add_column :containers, :box_id, :integer
  end
end
