class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.integer :ncbi_id
      t.integer :parent_ncbi_id
      t.string :rank
      t.string :ancestry, length: 1000
      t.integer :ancestry_depth, default: 0
    end
    add_index :taxons, :ncbi_id, :unique => true
    add_index :taxons, :parent_ncbi_id
    add_index :taxons, :ancestry
    add_index :taxons, :ancestry_depth
  end
end
