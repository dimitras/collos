class RenameExperimentTable < ActiveRecord::Migration
	def change
		rename_table :experiments, :investigations
	end 
end
