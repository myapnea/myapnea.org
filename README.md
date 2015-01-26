# OpenPPRN - MyApnea.Org

[![Build Status](https://travis-ci.org/myapnea/www_myapnea_org.svg?branch=master)](https://travis-ci.org/myapnea/www_myapnea_org)
[![Dependency Status](https://gemnasium.com/myapnea/www_myapnea_org.svg)](https://gemnasium.com/myapnea/www_myapnea_org)
[![Code Climate](https://codeclimate.com/github/myapnea/www_myapnea_org/badges/gpa.svg)](https://codeclimate.com/github/myapnea/www_myapnea_org)

A collaboration to build an open-source solution for creating patient-powered research networks.

## Before Starting Installation

Make sure you have reviewed and installed any [prerequisites](https://github.com/myapnea/www_myapnea_org/blob/master/PREREQUISITES.md).

## Installation

```
gem install bundler
```

This README assumes the following installation directory: /var/www/www_myapnea_org

```
cd /var/www

git clone https://github.com/myapnea/www_myapnea_org.git

cd www_myapnea_org

bundle install
```

Install default configuration files for database connection, email server connection, server url, and application name.

```
ruby lib/initial_setup.rb

bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake assets:precompile RAILS_ENV=production
```

To set up your secret keys, run

```
figaro install
```

Add the following lines to the /config/application.yml file it generates, complete with appropriate keys you've gotten from the third party developers. For any service you aren't using, you can leave the lines out:

```
uservoice_api_key:
google_analytics_web_property_id:
```

Open PPRN.rb to
- Configure the basic information about your PPRN

Run Rails Server (or use Apache or nginx)

```
rails s
```

Open a browser and go to: [http://localhost:3000](http://localhost:3000)

All done!
