class CreateOntologyTerms < ActiveRecord::Migration
  def change
    create_table :ontology_terms do |t|
      t.references :ontology, null: false
      t.string :accession, null: false
      t.string :name, null: false
      t.string :definition
      t.boolean :obsolete, default: false
    end
    add_index :ontology_terms, :ontology_id
    add_index :ontology_terms, :accession
    add_index :ontology_terms, :name
  end
end
