# MyApnea

[![Build Status](https://travis-ci.com/myapnea/myapnea.org.svg?branch=master)](https://travis-ci.com/myapnea/myapnea.org)
[![Code Climate](https://codeclimate.com/github/myapnea/myapnea.org/badges/gpa.svg)](https://codeclimate.com/github/myapnea/myapnea.org)

The web framework behind https://myapnea.org, built Rails 6.1+ and Ruby 3.0+.

## Before Starting Installation

Make sure you have reviewed and installed any
[prerequisites](https://github.com/myapnea/myapnea.org/blob/master/PREREQUISITES.md).

## Installation

```
gem install bundler
```

This README assumes the following installation directory:
`/var/www/myapnea.org`

```
cd /var/www

git clone https://github.com/myapnea/myapnea.org.git

cd myapnea.org

bundle install
```

Install default configuration files for database connection, email server
connection, server url, and application name.

```
ruby lib/initial_setup.rb

rails db:migrate RAILS_ENV=production

rails assets:precompile RAILS_ENV=production
```

Edit the `/config/application.yml` file it generates, and enter any keys you've
gotten from the third party developers. For any service you aren't using, you
can leave the lines out.

Run Rails Server (or use Apache or nginx)

```
rails s
```

Open a browser and go to: [http://localhost:3000](http://localhost:3000)

All done!

## Refreshing Sitemap

Edit Cron Jobs `sudo crontab -e` to run the task `lib/tasks/sitemap.rake`

```
SHELL=/bin/bash
0 1 * * * source /etc/profile.d/rvm.sh && cd /var/www/myapnea.org && rvm 3.0.2 && rails sitemap:refresh RAILS_ENV=production
```

## License

MyApnea is released under the [MIT License](http://www.opensource.org/licenses/MIT).
