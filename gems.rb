# frozen_string_literal: true

# rubocop:disable Layout/ExtraSpacing
source "https://rubygems.org"

gem "rails",                      "6.1.6"

# PostgreSQL as the Active Record database.
gem "pg",                         "1.2.3"

# Gems used by project.
gem "acts_as_textcaptcha",        "~> 4.6.0"
gem "autoprefixer-rails"
gem "bootstrap",                  "~> 4.4.1"
gem "carrierwave",                "~> 2.2.1"
gem "devise",                     "~> 4.7.3"
gem "figaro",                     "~> 1.2.0"
gem "font-awesome-sass",          "~> 5.12.0"
gem "haml",                       "~> 5.2.1"
gem "hashids",                    "~> 1.0.5"
gem "jquery-ui-rails",            "~> 6.0.1"
gem "kaminari",                   "~> 1.2.1"
gem "mini_magick",                "~> 4.9.3"
gem "net-imap",                   require: false
gem "net-pop",                    require: false
gem "net-smtp",                   require: false
gem "pg_search",                  "~> 2.3.2"
gem "redcarpet",                  "~> 3.5.1"
gem "rubyzip",                    "~> 2.3.0"
gem "sitemap_generator",          "~> 6.0.2"
gem "concurrent-ruby",            "1.3.4"

# Rails defaults.
gem "coffee-rails",               "~> 5.0"
gem "sass-rails",                 ">= 6"
gem "uglifier",                   ">= 1.3.0"

gem "jbuilder",                   "~> 2.9"
gem "jquery-rails",               "~> 4.3.5"
gem "turbolinks",                 "~> 5"

group :development do
  gem "listen",                   "~> 3.3"
  gem "spring"
  gem "spring-watcher-listen",    "~> 2.0.0"
  gem "web-console",              ">= 4.1.0"
end

# Testing
group :test do
  gem "artifice"
  gem "capybara",                 ">= 3.26"
  gem "minitest"
  gem "puma"
  gem "selenium-webdriver"
  gem "simplecov",                "~> 0.16.1", require: false
end
# rubocop:enable Layout/ExtraSpacing
