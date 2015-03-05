# Add to assets path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')

# Had to add these here to get in Precompile Package
Rails.application.config.assets.precompile += %w( pages.css )
Rails.application.config.assets.precompile += %w( social/maps.js social/places.js typeahead-addresspicker.js google_analytics.js uservoice.js )
Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf)
Rails.application.config.assets.precompile += %w( bootswatch.js )
Rails.application.config.assets.precompile += %w( home.js dashboard.js)
Rails.application.config.assets.precompile += %w( reports/default.js reports/report_13.js )

# Kyle's new redesign
Rails.application.config.assets.precompile += %w( application.css application.js )
