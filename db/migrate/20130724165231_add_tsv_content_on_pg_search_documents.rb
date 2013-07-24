class AddTsvContentOnPgSearchDocuments < ActiveRecord::Migration
  def up
    add_column :pg_search_documents, :tsv_content, :tsvector
    # update trigger
    connection.execute("CREATE TRIGGER pg_search_documents_tsvupdate BEFORE INSERT OR UPDATE ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv_content, 'pg_catalog.english', content)")
  end

  def down
    connection.execute("DROP TRIGGER  pg_search_documents_tsvupdate  ON pg_search_documents")
    remove_column :pg_search_documents, :tsv_content
  end
end
