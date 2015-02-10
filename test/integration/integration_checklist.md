# Integration Checklist

## Setup
1. [ ] `git pull`

2. [ ] `bundle update`

3. [ ] Reset Database

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

4. [ ] Start (or restart) server

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
   - Fill in email with `user_1@gmail.com`, and password with `password`
   - Press `Enter` button
   - Ensure redirected to homepage and logged in

##
## Surveys
##