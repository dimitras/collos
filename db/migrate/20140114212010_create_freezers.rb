class CreateFreezers < ActiveRecord::Migration
  def change
    create_table :freezers do |t|
      t.string :label
      t.integer :freezer_type_id

      t.timestamps
    end
  end
end
