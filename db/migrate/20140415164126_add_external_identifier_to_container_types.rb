class AddExternalIdentifierToContainerTypes < ActiveRecord::Migration
  def change
  	add_column :container_types, :can_have_external_identifier, :boolean, default: false
  end
end
