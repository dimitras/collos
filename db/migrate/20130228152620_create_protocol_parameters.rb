class CreateProtocolParameters < ActiveRecord::Migration
  def change
    create_table :protocol_parameters do |t|
      t.references :protocol
      t.string :name
      t.string :description
      t.string :default_value
      t.references :unit_type
      t.string :unit

      t.timestamps
    end
    add_index :protocol_parameters, :protocol_id
    add_index :protocol_parameters, :unit_type_id
  end
end
