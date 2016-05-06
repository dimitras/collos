class AddImportedToInvestigations < ActiveRecord::Migration
  def change
    add_column :investigations, :imported, :boolean
  end
end
