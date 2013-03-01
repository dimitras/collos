class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.references :barcode
      t.references :container_type
      t.string :ancestry, null: false
      t.integer :ancestry_depth, default: 0
      t.integer :x, default: 0
      t.integer :y, default: 0
      t.boolean :retired, default: false
      t.timestamps
    end
    add_index :containers, :container_type_id
    add_index :containers, :barcode_id, unique: true
    add_index :containers, :ancestry

  end
end
