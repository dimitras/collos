class AddShippedInContainer < ActiveRecord::Migration
  def change
  	add_column :containers, :shipped, :boolean
  end
end
