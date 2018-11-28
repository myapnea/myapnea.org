class AddOverviewReportPdfToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :overview_report_pdf, :string
    add_column :subjects, :overview_report_pdf_file_size, :bigint, null: false, default: 0
  end
end
