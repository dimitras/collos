class AddSelfJoinIdToContainer < ActiveRecord::Migration
  def change
  	add_column :containers, :ancestry_id, :integer
  end
end
