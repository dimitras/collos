class AddToContainerType < ActiveRecord::Migration
	def change
		add_column :container_types, :label, :string
	end
end
