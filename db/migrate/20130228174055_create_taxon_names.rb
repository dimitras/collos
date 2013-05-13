class CreateTaxonNames < ActiveRecord::Migration
  def change
    create_table :taxon_names do |t|
      t.references :taxon
      t.integer :ncbi_taxon_id, null: false
      t.string :name, null: false
      t.string :name_class, length: 50
    end
    add_index :taxon_names, :taxon_id
    add_index :taxon_names, :ncbi_taxon_id
    add_index :taxon_names, [:name, :name_class]
  end
end
