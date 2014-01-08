class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :type
      t.string :institution

      t.timestamps
    end
  end
end
