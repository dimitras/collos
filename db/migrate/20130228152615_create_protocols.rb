class CreateProtocols < ActiveRecord::Migration
  def change
    create_table :protocols do |t|
      t.integer :protocol_type_id
      t.string :name
      t.string :description
      t.string :accession
      t.string :uri

      t.timestamps
    end
    add_index :protocols, :protocol_type_id
    add_index :protocols, :name
    add_index :protocols, :accession

  end
end
