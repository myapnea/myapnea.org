# frozen_string_literal: true

# Loads banlist once into memory
ban_file = Rails.root.join('config', 'banlist.yml')
BANNED_IPS = if File.exist? ban_file
               YAML.load_file(ban_file)
             else
               []
             end
