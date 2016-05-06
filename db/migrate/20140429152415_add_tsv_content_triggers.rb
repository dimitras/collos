class AddTsvContentTriggers < ActiveRecord::Migration
	def up
		add_column :studies, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER studies_tsvupdate BEFORE INSERT OR UPDATE ON studies FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', title, identifier, description)")

		add_column :investigations, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER investigations_tsvupdate BEFORE INSERT OR UPDATE ON investigations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', title, identifier)")

		add_column :material_types, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER material_types_tsvupdate BEFORE INSERT OR UPDATE ON material_types FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', name)")

		add_column :people, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER people_tsvupdate BEFORE INSERT OR UPDATE ON people FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', firstname, lastname, email, institution)")

		add_column :shipments, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER shipments_tsvupdate BEFORE INSERT OR UPDATE ON shipments FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', tracking_number)")

		add_column :taxons, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER taxons_tsvupdate BEFORE INSERT OR UPDATE ON taxons FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', scientific_name, common_name)")
	end

	def down
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
