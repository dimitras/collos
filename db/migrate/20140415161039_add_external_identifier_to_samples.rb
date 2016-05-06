class AddExternalIdentifierToSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :external_identifier, :string
  	add_index :samples, :external_identifier
  end
end
