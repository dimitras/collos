class CreateTaxonNames < ActiveRecord::Migration
  def change
    create_table :taxon_names do |t|
      t.references :taxon
      t.string :name
      t.string :uniq_name
      t.string :name_class
    end
    add_index :taxon_names, :taxon_id
    add_index :taxon_names, [:name, :uniq_name]
  end
end
