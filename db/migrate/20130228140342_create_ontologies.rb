class CreateOntologies < ActiveRecord::Migration
  def change
    create_table :ontologies do |t|
      t.string :name, null: false
      t.string :release,
      t.string :description, length: 500
      t.string :uri, null: false
      t.string :prefix, null: false

    end
    add_index :ontologies, :name
    add_index :ontologies, :uri
    add_index :ontologies, :prefix
  end
end
