class RemoveBoxFromContainer < ActiveRecord::Migration
  def change
  	remove_column :containers, :box_id
  end
end
