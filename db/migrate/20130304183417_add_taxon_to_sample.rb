class AddTaxonToSample < ActiveRecord::Migration
  def change
    change_table :samples do |t|
      t.integer :taxon_id
      t.index :taxon_id
    end
  end
end
