class CreateProtocolApplications < ActiveRecord::Migration
  def change
    create_table :protocol_applications do |t|
      t.references :protocol
      t.references :operator
      t.date :procedure_date

      t.timestamps
    end
    add_index :protocol_applications, :protocol_id
    add_index :protocol_applications, :operator_id
  end
end
