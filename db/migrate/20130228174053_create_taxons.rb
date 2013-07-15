class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.integer :ncbi_id, null: false
      t.string :scientific_name
      t.string :common_name
    end
    add_index :taxons, :ncbi_id, :unique => true
    add_index :taxons, :scientific_name, :unique => true
    add_index :taxons, :common_name
  end
end
