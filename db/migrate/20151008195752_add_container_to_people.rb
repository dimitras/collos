class AddContainerToPeople < ActiveRecord::Migration
  def change
    add_column :people, :container_id, :integer
  end
end
