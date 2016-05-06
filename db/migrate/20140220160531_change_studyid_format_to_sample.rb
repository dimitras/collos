class ChangeStudyidFormatToSample < ActiveRecord::Migration
  def change
  	remove_column :samples, :study_id
  	add_column :samples, :study_id, :integer
  end
end
