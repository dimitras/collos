class AddStudyIdToPeople < ActiveRecord::Migration
  def change
	  add_column :people, :study_id, :integer
  end
end
