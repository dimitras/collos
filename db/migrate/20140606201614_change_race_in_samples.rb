class ChangeRaceInSamples < ActiveRecord::Migration
	def change
		remove_column :samples, :race
		add_column :samples, :race_id, :integer
		remove_column :samples, :ethnicity
		add_column :samples, :ethnicity_id, :integer

		add_index :samples, :race_id
		add_index :samples, :time_point
		add_index :samples, :ethnicity_id
		add_index :samples, :source_name
		add_index :samples, :tissue_type_id
		add_index :samples, :material_type_id
		add_index :samples, :primary_cell_id
		add_index :samples, :strain_id
		add_index :samples, :age_id
		add_index :samples, :sex_id
		add_index :samples, :genotype
		add_index :samples, :treatments
		add_index :samples, :protocols
	end
end
