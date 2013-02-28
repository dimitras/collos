class CreateContainerTypes < ActiveRecord::Migration
  def change
    create_table :container_types do |t|
      t.references :type
      t.string :name
      t.integer :x_dimension
      t.integer :y_dimension
      t.string :x_coord_labels
      t.string :y_coord_labels

      t.timestamps
    end
    add_index :container_types, :type_id
  end
end
