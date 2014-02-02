class ChangeInvestigation < ActiveRecord::Migration
  def change
  	rename_column :investigations, :name, :title
	rename_column :investigations, :study_id, :identifier
	change_column :investigations, :identifier, :text
  end
end
