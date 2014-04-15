class AddExternalIdentifierToContainers < ActiveRecord::Migration
  def change
  	add_column :containers, :external_identifier, :string
  	add_index :containers, :external_identifier
  end
end
