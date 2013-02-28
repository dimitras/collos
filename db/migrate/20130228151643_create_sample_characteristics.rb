class CreateSampleCharacteristics < ActiveRecord::Migration
  def change
    create_table :sample_characteristics do |t|
      t.references :ontology_term
      t.string :name
      t.string :value
      t.references :unit_type
      t.string :unit

      t.timestamps
    end
    add_index :sample_characteristics, :ontology_term_id
    add_index :sample_characteristics, :unit_type_id
  end
end
