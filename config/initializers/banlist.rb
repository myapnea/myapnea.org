# frozen_string_literal: true

# Loads banlist once into memory.
ban_file = Rails.root.join("config", "banlist.yml")
BANNED_IPS = \
  if File.exist? ban_file
    YAML.load_file(ban_file)
  else
    []
  end

ban_email = Rails.root.join("config", "banemail.yml")
BANNED_EMAILS = \
  if File.exist?(ban_email)
    YAML.load_file(ban_email)
  else
    []
  end

url_regex = Rails.root.join("config", "urlregex.yml")
URL_RULES = \
  if File.exist?(url_regex)
    YAML.load_file(url_regex).collect { |r| "(?:#{r})" }.join("|")
  else
    []
  end
