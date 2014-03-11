class AddAncestryToSamples < ActiveRecord::Migration
	def change
		add_column :samples, :ancestry, :string, limit: 500
		add_column :samples, :ancestry_depth, :integer, default: 0
		add_index :samples, :ancestry
	end
end
