class AddConfirmedToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :confirmed, :boolean
  end
end
