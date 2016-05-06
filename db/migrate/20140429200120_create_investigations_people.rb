class CreateInvestigationsPeople < ActiveRecord::Migration
	def change
		create_table :investigations_people, :id => false do |t|
			t.integer :investigation_id
      		t.integer :person_id
		end
		add_index :investigations_people, :investigation_id
    	add_index :investigations_people, :person_id
	end
end
