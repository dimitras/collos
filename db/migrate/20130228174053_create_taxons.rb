class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.integer :parent_taxon_id
      t.integer :ncbi_id, null: false
      t.integer :parent_ncbi_id
      t.string :rank, length: 50

    end
    add_index :taxons, :parent_taxon_id
    add_index :taxons, :ncbi_id, :unique => true
    add_index :taxons, :parent_ncbi_id
  end
end
