class RemoveDimensionsFromBox < ActiveRecord::Migration
  def change
  	remove_column :boxes, :dimension_x
    remove_column :boxes, :dimension_y
  end
end
