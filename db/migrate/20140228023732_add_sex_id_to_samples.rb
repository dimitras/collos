class AddSexIdToSamples < ActiveRecord::Migration
  def change
	  remove_column :samples, :sex
	  add_column :samples, :sex_id, :integer
  end
end
