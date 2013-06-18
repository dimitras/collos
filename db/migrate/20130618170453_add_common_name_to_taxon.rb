class AddCommonNameToTaxon < ActiveRecord::Migration
  def change
    add_column :taxons, :common_name, :string
  end
end
