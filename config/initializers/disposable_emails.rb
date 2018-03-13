# frozen_string_literal: true

disposable_emails = Rails.root.join("lib", "data", "spam", "disposable_emails.yml")
DISPOSABLE_EMAILS = (File.exist?(disposable_emails) ? YAML.load_file(disposable_emails) : [])
