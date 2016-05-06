class CreatePeopleStudies < ActiveRecord::Migration
	def change
		create_table :people_studies, :id => false do |t|
			t.integer :person_id
      		t.integer :study_id
		end
		add_index :people_studies, :person_id
    	add_index :people_studies, :study_id
	end
end
