class CreateContainerTypes < ActiveRecord::Migration
  def change
    create_table :container_types do |t|
      t.references :type
      t.string :name
      t.integer :x_dimension, default: 1
      t.integer :y_dimension, default: 1
      t.string :x_coord_labels, default: 'number'
      t.string :y_coord_labels, default: 'number'
      t.timestamps
    end
    add_index :container_types, :type_id
  end
end
