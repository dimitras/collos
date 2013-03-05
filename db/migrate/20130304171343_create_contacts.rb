class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.belongs_to :address

      t.timestamps
    end
    add_index :contacts, :address_id
  end
end
