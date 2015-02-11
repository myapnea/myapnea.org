# Integration Checklist

## Setup

1. [ ] Reset Database

   ```
   bundle exec rake db:drop RAILS_ENV=integration_test
   bundle exec rake db:create RAILS_ENV=integration_test
   bundle exec rake db:migrate RAILS_ENV=integration_test
   bundle exec rake db:fixtures:load RAILS_ENV=integration_test
   bundle exec rake surveys:load["about-me"] RAILS_ENV=integration_test
   bundle exec rake surveys:load["about-my-family"] RAILS_ENV=integration_test
   bundle exec rake surveys:load["additional-information-about-me"] RAILS_ENV=integration_test
   bundle exec rake surveys:load["my-sleep-pattern"] RAILS_ENV=integration_test
   bundle exec rake surveys:refresh RAILS_ENV=integration_test
   ```

2. Profit??

## Registration

### Providers

### Users



##
## Surveys
##
