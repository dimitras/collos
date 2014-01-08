class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.text :name

      t.timestamps
    end
  end
end
