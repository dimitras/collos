class CreateProtocolParameterValues < ActiveRecord::Migration
  def change
    create_table :protocol_parameter_values do |t|
      t.references :protocol_application
      t.references :protocol_parameter
      t.string :value
      t.string :unit

      t.timestamps
    end
    add_index :protocol_parameter_values, :protocol_application_id
    add_index :protocol_parameter_values, :protocol_parameter_id
  end
end
