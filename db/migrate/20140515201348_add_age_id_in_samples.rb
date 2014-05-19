class AddAgeIdInSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :age_id, :integer
  end
end
