class CreateSampleRelationships < ActiveRecord::Migration
  def change
    create_table :sample_relationships do |t|
      t.integer :ancestor_id
      t.integer :descendant_id
      t.boolean :direct
      t.integer :count
    end
    add_index :sample_relationships, :ancestor_id
    add_index :sample_relationships, :descendant_id
  end
end
