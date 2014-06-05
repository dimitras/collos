class AddProtocolsToSamples < ActiveRecord::Migration
	def change
		add_column :samples, :protocols, :string
		add_column :samples, :race, :string
	end
end
