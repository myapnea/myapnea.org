class ChangePgSearchDocumentIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :pg_search_documents, :id, :bigint

    change_column :pg_search_documents, :searchable_id, :bigint
  end

  def down
    change_column :pg_search_documents, :id, :integer

    change_column :pg_search_documents, :searchable_id, :integer
  end
end
