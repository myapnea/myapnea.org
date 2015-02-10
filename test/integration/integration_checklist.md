# Integration Checklist

## Setup

1. [ ] Reset Database

   ```
   bundle exec rake db:drop
   bundle exec rake db:create
   bundle exec rake db:migrate
   bundle exec rake db:fixtures:load
   bundle exec rake surveys:load["about-me"]
   bundle exec rake surveys:load["about-my-family"]
   bundle exec rake surveys:load["additional-information-about-me"]
   bundle exec rake surveys:load["my-sleep-pattern"]
   bundle exec rake surveys:refresh
   ```

2. Profit??

## Registration

### Providers

### Users



##
## Surveys
##