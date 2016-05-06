class AddFieldsInSample < ActiveRecord::Migration
	def change
		add_column :samples, :strain_id, :integer
		add_column :samples, :tissue_type_id, :integer
		add_column :samples, :primary_cell_id, :integer
		add_column :samples, :treatments, :string
		add_column :samples, :genotype, :string
		add_column :samples, :replicate, :string
	end
end
