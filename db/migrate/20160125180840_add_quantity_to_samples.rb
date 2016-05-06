class AddQuantityToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :quantity, :string
  end
end
