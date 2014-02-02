class ChangeFreezerType < ActiveRecord::Migration
  def change
  	rename_column :freezer_types, :label, :name
  end
end
