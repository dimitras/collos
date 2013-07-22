class CreateAddressesUsers < ActiveRecord::Migration
  def change
    create_table :addresses_users, id: false do |t|
      t.integer :address_id, null: false
      t.integer :user_id, null: false
    end
    add_index :addresses_users, :address_id
    add_index :addresses_users, :user_id
  end
end
