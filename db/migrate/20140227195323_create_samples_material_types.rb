class CreateSamplesMaterialTypes < ActiveRecord::Migration
	def change
		create_table :samples_material_types, id: false do |t|
			t.integer :sample_id, null: false
			t.integer :material_type_id, null: false
			t.timestamps
		end
		add_index :samples_material_types, :sample_id
		add_index :samples_material_types, :material_type_id
	end
end