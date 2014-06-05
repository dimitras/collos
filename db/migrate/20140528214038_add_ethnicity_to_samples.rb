class AddEthnicityToSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :ethnicity, :string
  end
end
