# frozen_string_literal: true

# Loads banned emails into memory.
ban_email = Rails.root.join('config', 'banemail.yml')
BANNED_EMAILS = (File.exist?(ban_email) ? YAML.load_file(ban_email) : [])
