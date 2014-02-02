class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :label
      t.integer :box_type_id
      t.integer :dimension_x
      t.integer :dimension_y
      t.integer :freezer_id

      t.timestamps
    end
  end
end
