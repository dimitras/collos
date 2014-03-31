class AddMaterialIdToSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :material_type_id, :integer
  end
end
