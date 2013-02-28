class CreateProtocols < ActiveRecord::Migration
  def change
    create_table :protocols do |t|
      t.string :name
      t.string :description
      t.string :accession
      t.string :uri

      t.timestamps
    end
  end
end
