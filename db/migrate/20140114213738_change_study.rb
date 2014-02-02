class ChangeStudy < ActiveRecord::Migration
  def change
  	add_column :studies, :investigation_id, :integer
  end
end
