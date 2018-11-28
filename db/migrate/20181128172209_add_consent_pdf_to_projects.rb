class AddConsentPdfToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :consent_pdf, :string
    add_column :projects, :consent_pdf_file_size, :bigint, null: false, default: 0
  end
end
