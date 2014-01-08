class ChangeStudyFormats < ActiveRecord::Migration
	def change
		change_column :studies, :description, :text
	end
end
