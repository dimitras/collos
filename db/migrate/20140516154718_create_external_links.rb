class CreateExternalLinks < ActiveRecord::Migration
	def change
		create_table :external_links do |t|
			t.string :name
		  	t.string :url

		  	t.timestamps
		end
	end
end
