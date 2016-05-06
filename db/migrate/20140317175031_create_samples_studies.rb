class CreateSamplesStudies < ActiveRecord::Migration
	def change
		create_table :samples_studies, :id => false do |t|
			t.integer :sample_id
      		t.integer :study_id
		end
		add_index :samples_studies, :sample_id
    	add_index :samples_studies, :study_id
	end
end
