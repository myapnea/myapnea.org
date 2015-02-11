# Integration Checklist

## Setup
- [ ] `git pull`

- [ ] `bundle update`

- [ ] Reset Database

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

- [ ] Start (or restart) server

## Registration

### Users
1. [ ] Navigate to home page.

2. [ ] Scroll to bottom registration form.

3. [ ] **Missing form information**
   - Fill in form with the following 5 fields missing:
      - First name: `Some`
      - Last name:  `User`
      - Birth year: `1980`
      - email:      `someuser@gmail.com`
      - password:   `password`
   - Ensure error message matches missing field.
   - Ensure no form information is lost.

4. [ ] **Incorrect form information**
   - Do the following:
      - Fill in form with non-numeric year
      - Fill in form with year 2010
      - Fill in incorrect email address format
      - Fill in password of length < 8
      - Fill in email with duplicate: `tommyboy@gmail.com`
   - Ensure error message matches error
   - Ensure no form information is lost

5. [ ] **Successful signup flow**
   - Fill out form with the fields from above
   - Submit using `Enter` key
   - Ensure user is taken to home page, with signed in user information showing up on the sidebar.

   - Go back to homepage
   - Fill out form with the fields from above.
   - Ensure error pops up for duplicate email.
   - Ensure form displays under `users` route.
   - Change email to `someuser1980@gmail.com`
   - Submit by clicking `Submit` button
   - Ensure user is taken to home page, with signed in user information showing up on the sidebar.

### Providers


## Sign In

### Users
1. [ ] Sign out if signed in as a user.

2. [ ] Go to home page

3. [ ] **Sign in errors**
   - Fill in password with `password`
   - Click `Login` button
   - Ensure error is correctly handled
   - Repeat with:
      - No password
      - Non-existing email: `notexisting@gmail.com`
      - Incorrect password: `password1`
4. [ ] **Successful sign in**
   - Fill in email with `user_1@mail.com`, and password with `password`
   - Press `Enter` button
   - Ensure redirected to homepage and logged in


## Surveys
Test using:
- [ ] Internet explorer
- [ ] Firefox
- [ ] Google Chrome

### Consent and Privacy
- [ ] Sign in with `user_2@mail.com`, `password` combo
- [ ] *Temporary* Enable beta by clicking on button
- [ ] Return to home page
- In survey section, click on `About Me` survey.
*ERROR!*

### New Survey Type
- [ ] Sign in with `tommyboy@gmail.com`, `password`
- [ ] Enable Beta and return to home page
#### Main Flow
- [ ] Click on `About Me` survey
   - [ ] Fill in date question and refresh page. Answer should persist
   - [ ] Fill in questions and check persistence:
      - [ ] Clicking `Go to next question` button
      - [ ] Hitting `Enter` key
      - [ ] Setting focus, then clicking on an option.
      - [ ] Setting focus, then using hotkeys.
      - [ ] Clicking on and option on a question w/o any focus
      - [ ] Clicking elsewhere on page to lose focus
#### Nested inputs
- [ ] In the `What is your race?` question, choose the `H` option.
- [ ] Enter some custom race, and go to next question.
- [ ] Ensure persistence.
- [ ] Set focus to **Race** question by clicking in the question area.
- [ ] Ensure focus *DOES NOT* switch to nested input.
- [ ] Click on `Research Surveys` link in side bar.
- [ ] Select `About my family` survey.
- [ ] Ensure survey title and information are visible.
- [ ] Click on `Other country` option in first question.
- [ ] Ensure nested input renders properly.
- [ ] Ensure typing hotkey values when focus is on nested input does not cause a loss of focus.
- [ ] Proceed to next question with `Enter`.
#### Survey Report



