class AddContactToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :contact_id
      t.index :contact_id
    end
  end
end
