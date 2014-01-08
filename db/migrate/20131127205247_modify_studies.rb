class ModifyStudies < ActiveRecord::Migration
	def change
		rename_column :studies, :name, :title
		add_column :studies, :identifier, :string
		add_column :studies, :description, :string
	end
end
