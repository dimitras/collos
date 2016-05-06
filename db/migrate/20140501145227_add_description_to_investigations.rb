class AddDescriptionToInvestigations < ActiveRecord::Migration
  def change
  	add_column :investigations, :description, :text
  	change_column :investigations, :identifier, :string
  end
end
