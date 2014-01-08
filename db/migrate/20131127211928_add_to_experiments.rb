class AddToExperiments < ActiveRecord::Migration
	def change
		add_column :experiments, :study_id, :integer
	end
end
