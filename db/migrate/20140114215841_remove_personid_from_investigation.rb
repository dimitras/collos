class RemovePersonidFromInvestigation < ActiveRecord::Migration
  def change
  	remove_column :investigations, :person_id
  end
end
