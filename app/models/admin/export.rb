# frozen_string_literal: true

# Allows admins to generate exports.
class Admin::Export < ApplicationRecord
  # Uploaders
  mount_uploader :file, ZipUploader

  # Concerns
  include Forkable

  # Model Validation
  validates :user_id, presence: true

  # Model Relationships
  belongs_to :user

  # Model Methods

  def name
    created_at.strftime("%-d %B %Y, %-l:%M %p")
  end

  def percent
    return 0 if total_steps.zero? && %w(started failed).include?(status)
    total_steps.positive? ? current_step * 100 / total_steps : 100
  end

  def start_export_in_background!
    fork_process :start_export
  end

  private

  def number_of_steps
    exportable_users.count + 2
  end

  def start_export
    update current_step: 0, total_steps: number_of_steps
    finalize_export generate_zip_file
  rescue => e
    export_failed e.message.to_s + e.backtrace.to_s
  end

  # Zip multiple files, or zip one file if it's part of the sheet uploaded
  # files, always zip folder
  def generate_zip_file
    filename = "myapnea-data-#{created_at.strftime("%Y%m%d%H%M")}"
    all_files = generate_all_files(filename)

    return if all_files.empty?

    # Create a zip file
    zipfile_name = File.join("tmp", "exports", "#{filename}-#{SecureRandom.hex(4)}.zip")
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      all_files.uniq.each do |location, input_file|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(location, input_file) if File.exist?(input_file) && File.size(input_file).positive?
      end
    end
    zipfile_name
  end

  def generate_all_files(filename)
    export_data(filename) + export_sas(filename)
  end

  def export_data(filename)
    data_csv = File.join("tmp", "exports", "#{filename}-#{created_at.strftime("%I%M%P")}-data.csv")
    write_data_csv(data_csv)
    [[data_csv.split("/").last.to_s, data_csv]]
  end

  def export_sas(filename)
    sas_filename = "#{filename}-#{created_at.strftime("%I%M%P")}.sas"
    sas_file = File.join("tmp", "exports", sas_filename)
    write_sas(sas_file, sas_filename)
    [[sas_file.split("/").last.to_s, sas_file]]
  end

  def finalize_export(export_file)
    if export_file
      export_succeeded export_file
    else
      export_failed "No files were added to zip file."
    end
  end

  def export_succeeded(export_file)
    update status: "completed",
           file: File.open(export_file),
           file_size: File.size(export_file),
           file_created_at: Time.zone.now,
           current_step: total_steps
    notify_user!
  end

  def export_failed(details)
    update status: "failed", details: details
  end

  def notify_user!
    UserMailer.export_ready(self).deliver_now if EMAILS_ENABLED
  end

  def write_data_csv(data_csv)
    CSV.open(data_csv, "wb") do |csv|
      csv << %w(myapnea_id joined)
      exportable_users.each do |user|
        csv << [user.myapnea_id, user.created_at.strftime("%Y-%m-%d")]
      end
    end
  end

  def write_sas(sas_file, sas_filename)
    @export_formatter = self
    @filename = sas_filename.gsub(/\.sas$/, "-data")
    erb_file = File.join("app", "views", "admin", "exports", "sas_export.sas.erb")
    File.open(sas_file, "w") do |file|
      file.syswrite(ERB.new(File.read(erb_file)).result(binding))
    end
    update current_step: current_step + 1
  end

  def exportable_users
    User.include_in_exports_and_reports.order(:id)
  end
end
