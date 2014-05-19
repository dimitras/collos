class AddAgeAndTimeInSamples < ActiveRecord::Migration
  def change
  	add_column :samples, :age, :integer
  	add_column :samples, :time_point, :string
  end
end
