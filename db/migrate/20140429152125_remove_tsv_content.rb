class RemoveTsvContent < ActiveRecord::Migration
  	def change
		remove_column :studies, :tsv_content
		connection.execute("DROP TRIGGER studies_tsvupdate ON studies")

		remove_column :investigations, :tsv_content
		connection.execute("DROP TRIGGER investigations_tsvupdate ON investigations")

		remove_column :material_types, :tsv_content
		connection.execute("DROP TRIGGER material_types_tsvupdate ON material_types")

		remove_column :people, :tsv_content
		connection.execute("DROP TRIGGER people_tsvupdate ON people")

		remove_column :shipments, :tsv_content
		connection.execute("DROP TRIGGER shipments_tsvupdate ON shipments")

		remove_column :taxons, :tsv_content
		connection.execute("DROP TRIGGER taxons_tsvupdate ON taxons")
	end
end
