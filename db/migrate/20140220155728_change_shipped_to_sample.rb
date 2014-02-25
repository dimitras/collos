class ChangeShippedToSample < ActiveRecord::Migration
  def change
  	rename_column :samples, :shipped, :study_id
  end
end
