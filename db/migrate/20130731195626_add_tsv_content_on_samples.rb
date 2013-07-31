class AddTsvContentOnSamples < ActiveRecord::Migration
  def up
    add_column :samples, :tsv_content, :tsvector
    # update trigger
    connection.execute("CREATE TRIGGER samples_tsvupdate BEFORE INSERT OR UPDATE ON samples FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', name, barcode_string, tags, notes)")
  end

  def down
    connection.execute("DROP TRIGGER  samples_tsvupdate  ON pg_search_documents")
    remove_column :samples, :tsv_content
  end
end
