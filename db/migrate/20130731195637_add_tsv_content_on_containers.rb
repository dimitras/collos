class AddTsvContentOnContainers < ActiveRecord::Migration
  def up
    add_column :containers, :tsv_content, :tsvector
    # update trigger
    connection.execute("CREATE TRIGGER containers_tsvupdate BEFORE INSERT OR UPDATE ON containers FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', name, barcode_string, tags, notes)")
  end

  def down
    connection.execute("DROP TRIGGER  containers_tsvupdate  ON pg_search_documents")
    remove_column :containers, :tsv_content
  end
end
