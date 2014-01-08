class AddMaterialToSample < ActiveRecord::Migration
	def up
		add_column :samples, :material_type, :string
	end
	def down
		remove_column :samples, :material_type
	end
end
