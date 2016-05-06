class AddSampleIdInLink < ActiveRecord::Migration
	def change
		add_column :external_links, :sample_id, :integer
	end
end
