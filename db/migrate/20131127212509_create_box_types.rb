class CreateBoxTypes < ActiveRecord::Migration
  def change
    create_table :box_types do |t|
      t.string :label
      t.integer :dimension_x
      t.integer :dimension_y
      t.integer :freezer_id

      t.timestamps
    end
  end
end
