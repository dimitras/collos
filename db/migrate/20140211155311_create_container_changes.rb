class CreateContainerChanges < ActiveRecord::Migration
  def change
    create_table :container_changes do |t|
      t.integer :container_id
      t.integer :past_ancestry_container_id
      t.integer :new_ancestry_container_id
      t.timestamps
    end
    add_index :container_changes, :container_id
  end
end
