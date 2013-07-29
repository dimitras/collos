class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :name
      t.references :taxon
      t.references :container
      t.integer :container_x
      t.integer :container_y
      t.references :protocol_application
      t.string :tags, limit: 500
      t.text :notes
      t.boolean :retired, default: false
      t.timestamps
    end
    add_index :samples, :name
    add_index :samples, :container_id
    add_index :samples, :taxon_id
    add_index :samples, :protocol_application_id
  end
end
