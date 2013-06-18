class AddScientificNameToTaxon < ActiveRecord::Migration
  def change
    add_column :taxons, :scientific_name, :string
  end
end
