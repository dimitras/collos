class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.references :container_type
      t.string :name
      t.string :ancestry, length: 500
      t.integer :ancestry_depth, default: 0
      t.integer :container_x, default: 0
      t.integer :container_y, default: 0
      t.boolean :retired, default: false
      t.text :notes
      t.timestamps
    end
    add_index :containers, :container_type_id
    add_index :containers, :ancestry

  end
end
