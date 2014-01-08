class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.text :name
      t.integer :person_id

      t.timestamps
    end
  end
end
