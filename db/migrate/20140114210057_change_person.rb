class ChangePerson < ActiveRecord::Migration
  def change
  	rename_column :people, :name, :firstname
	add_column :people, :lastname, :string
	add_column :people, :user_id, :integer
  end
end
