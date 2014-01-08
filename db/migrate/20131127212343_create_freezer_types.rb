class CreateFreezerTypes < ActiveRecord::Migration
  def change
    create_table :freezer_types do |t|
      t.string :label

      t.timestamps
    end
  end
end
