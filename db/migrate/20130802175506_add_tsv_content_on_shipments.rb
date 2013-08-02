class AddTsvContentOnShipments < ActiveRecord::Migration
 def up
    add_column :shipments, :tsv_content, :tsvector
    # update trigger
    connection.execute("CREATE TRIGGER shipments_tsvupdate BEFORE INSERT OR UPDATE ON shipments FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', name, barcode_string, tags, notes)")
  end

  def down
    connection.execute("DROP TRIGGER  shipments_tsvupdate  ON pg_search_documents")
    remove_column :shipments, :tsv_content
  end
end
