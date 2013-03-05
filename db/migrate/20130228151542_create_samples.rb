class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :name
      t.references :container
      t.references :taxon
      t.references :protocol_application
      t.string :ancestry, length: 500
      t.integer :ancestry_depth, default: 0
      t.timestamps
    end
    add_index :samples, :name
    add_index :samples, :ancestry
    add_index :samples, :container_id
    add_index :samples, :taxon_id
    add_index :samples, :protocol_application_id
  end
end
