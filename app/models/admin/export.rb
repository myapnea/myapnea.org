# frozen_string_literal: true

# Allows admins to generate exports.
class Admin::Export < ApplicationRecord
  # Constants
  STATUS = %w(started completed failed).collect { |i| [i, i] }

  # Uploaders
  mount_uploader :zipped_file, ZipUploader

  # Concerns
  include Forkable

  # Relationships
  belongs_to :user
  has_many :notifications

  # Methods
  def name
    created_at.strftime("%-d %B %Y, %-l:%M %p")
  end

  def destroy
    remove_zipped_file!
    super
  end

  def percent
    return 100 unless total_steps.positive?
    completed_steps * 100 / total_steps
  end

  def create_notification
    notification = user.notifications.where(admin_export_id: id).first_or_create
    notification.mark_as_unread!
  end

  def generate_export_in_background!
    update(total_steps: 6)
    fork_process(:generate_export!)
  end

  def filename
    "myapnea-data-#{created_at.strftime("%Y%m%d%H%M")}"
  end

  def generate_export!
    all_files = export_data + export_sas
    finalize_export!(all_files)
  rescue => e
    export_failed(e.message.to_s + e.backtrace.to_s)
  end

  def finalize_export!(all_files)
    # Create a zip file
    zip_name = "#{filename}.zip"
    temp_zip_file = Tempfile.new(zip_name)
    begin
      # Initialize temp zip file.
      Zip::OutputStream.open(temp_zip_file) { |zos| }
      # Write to temp zip file.
      Zip::File.open(temp_zip_file, Zip::File::CREATE) do |zip|
        all_files.uniq.each do |location, input_file|
          # Two arguments:
          # - The name of the file as it will appear in the archive
          # - The original file, including the path to find it
          zip.add(location, input_file) if File.exist?(input_file) && File.size(input_file).positive?
        end
      end
      temp_zip_file.define_singleton_method(:original_filename) do
        zip_name
      end
      update(
        zipped_file: temp_zip_file,
        file_created_at: Time.zone.now,
        status: "completed",
        completed_steps: total_steps
      )
      update file_size: zipped_file.size # Cache after attaching to model.
      create_notification
    ensure
      # Close and delete the temp file
      temp_zip_file.close
      temp_zip_file.unlink
    end
  end

  def export_failed(details)
    update(status: "failed", details: details)
    create_notification
  end

  private

  def export_data
    csv_name = "#{filename}-data.csv"
    temp_csv_file = Tempfile.new("#{filename}-inverted.csv")
    transposed_csv_file = Tempfile.new(csv_name)

    field_one = "NULLIF(users.full_name, '')::text"
    field_two = "users.username"
    full_name_or_username = "(CASE WHEN (#{field_one} IS NULL) THEN #{field_two} ELSE #{field_one} END)"

    CSV.open(temp_csv_file, "wb") do |csv|
      csv << ["MyApnea ID"] + exportable_users.pluck(:id).collect { |id| format("MA%06d", id) }
      update completed_steps: completed_steps + 1
      csv << ["Email"] + exportable_users.pluck(:email)
      update completed_steps: completed_steps + 1
      csv << ["Full Name or Username"] + exportable_users.pluck(Arel.sql(full_name_or_username))
      update completed_steps: completed_steps + 1
      csv << ["Emails Enabled"] + exportable_users.pluck(:emails_enabled)
      update completed_steps: completed_steps + 1
      csv << ["Email Confirmed"] + exportable_users.pluck(:confirmed_at).map { |timestamp| timestamp ? "Yes" : "No" }
      update completed_steps: completed_steps + 1
    end
    transpose_tmp_csv(temp_csv_file, transposed_csv_file)
    [[csv_name, transposed_csv_file]]
  end

  def export_sas
    sas_name = "#{filename}.sas"
    sas_file = Tempfile.new(sas_name)
    write_sas(sas_file)
    [[sas_name, sas_file]]
  end

  def write_sas(sas_file)
    @export_formatter = self
    @filename = "#{filename}-data"
    erb_file = File.join("app", "views", "admin", "exports", "sas_export.sas.erb")
    File.open(sas_file, "w") do |file|
      file.syswrite(ERB.new(File.read(erb_file)).result(binding))
    end
    update completed_steps: completed_steps + 1
  end

  def exportable_users
    User.current.order(:id)
  end

  def transpose_tmp_csv(temp_csv_file, transposed_csv_file)
    arr_of_arrs = CSV.parse(File.open(temp_csv_file, "r:iso-8859-1:utf-8", &:read))
    l = arr_of_arrs.map(&:length).max
    arr_of_arrs.map! { |e| e.values_at(0...l) }
    CSV.open(transposed_csv_file, "wb") do |csv|
      arr_of_arrs.transpose.each do |array|
        csv << array
      end
    end
  end
end
