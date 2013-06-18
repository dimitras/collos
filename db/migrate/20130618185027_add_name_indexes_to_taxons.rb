class AddNameIndexesToTaxons < ActiveRecord::Migration
  def change
    add_index :taxons, :scientific_name
    add_index :taxons, :common_name
  end
end
