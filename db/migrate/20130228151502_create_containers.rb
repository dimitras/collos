class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.references :container_type
      t.string :name
      t.string :ancestry, limit: 500
      t.integer :ancestry_depth, default: 0
      t.integer :parent_x, default: 0
      t.integer :parent_y, default: 0
      t.boolean :retired, default: false
      t.string :tags, limit: 500
      t.text :notes
      t.timestamps
    end
    add_index :containers, :container_type_id
    add_index :containers, :ancestry

  end
end
