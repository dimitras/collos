class CreateMaterialTypesSamples < ActiveRecord::Migration
	def change
		create_table :material_types_samples, id: false do |t|
			t.integer :material_type_id
			t.integer :sample_id
		end
		add_index :material_types_samples, :sample_id
		add_index :material_types_samples, :material_type_id
	end
end
