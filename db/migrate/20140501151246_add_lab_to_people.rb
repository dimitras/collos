class AddLabToPeople < ActiveRecord::Migration
  def change
  	add_column :people, :laboratory, :string
  	add_column :people, :identifier, :string
  end
end
