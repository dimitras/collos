class ChangeSample < ActiveRecord::Migration
  def change
  	rename_column :samples, :material_type, :shipped
  	add_column :samples, :sex, :string
  	add_column :samples, :source_name, :string
  end
end
