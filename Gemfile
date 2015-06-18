source 'https://rubygems.org'

# Required in Rails 4 for logs to work on heroku production
# gem 'rails_12factor', group: :production
# gem 'airbrake'

# To be removed if fixed in sprockets-rails 2.3.1 or higher
gem 'sprockets-rails', '2.2.4'

### Rack 1.6.3 breaks navigation tests, hardcoding to 1.6.2 for time being
gem 'rack',                 '1.6.2'

gem 'thin'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.2'
# Use postgresql as the database for Active Record
gem 'pg'

# User HAML for views
gem 'haml'

# Debugging
gem 'byebug'

# Helps Store Secrets Securely for Heroku Deploys
gem 'figaro'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
# gem 'spring', group: :development

# Bootstrap and Styles
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
# autoprefixer-rails 5.0.0 breaks, locking autoprefixer-rails to 4.0.2.2 for the time being
gem 'autoprefixer-rails', '4.0.2.2'
gem 'font-awesome-rails'

# Authentication
gem 'devise'

# String Matching
gem 'fuzzy_match'

# Markdown Support
gem 'redcarpet', '~> 3.3.1'

# Directed Acyclic Graph
gem 'acts-as-dag'

# Authorization
gem 'authority'

# Facebook
gem 'koala'

# Forum
gem 'kaminari', '~> 0.16.3'

# Blogs and Notifications
gem 'acts-as-taggable-on'

# User Profile
gem 'geocoder'
gem 'carrierwave'
gem 'mini_magick'

# Search Engine Optimization (SEO)
gem 'sitemap_generator'

gem 'merit'

# For Third-Party API Connections
gem 'faraday'

# Testing
group :test do
  # Pretty printed test output
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'simplecov',          '~> 0.10.0',           require: false
end

group :development, :test do
  # Access an IRB console on exceptions page and /console in development
  gem 'web-console', '~> 2.0'
end
