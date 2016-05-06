class AddTsvContent < ActiveRecord::Migration
	def change
		add_column :studies, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER studies_tsvupdate BEFORE INSERT OR UPDATE ON studies FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', title, identifier, description, investigation_title)")

		add_column :investigations, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER investigations_tsvupdate BEFORE INSERT OR UPDATE ON investigations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', title, identifier)")

		add_column :material_types, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER material_types_tsvupdate BEFORE INSERT OR UPDATE ON material_types FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', name)")

		add_column :people, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER people_tsvupdate BEFORE INSERT OR UPDATE ON people FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', firstname, lastname, email, institution)")

		add_column :shipments, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER shipments_tsvupdate BEFORE INSERT OR UPDATE ON shipments FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', receiver, shipper, tracking_number)")

		add_column :taxons, :tsv_content, :tsvector
		connection.execute("CREATE TRIGGER taxons_tsvupdate BEFORE INSERT OR UPDATE ON taxons FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', ncbi_id, scientific_name, common_name)")
	end
end
