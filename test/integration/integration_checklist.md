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
- [ ] Start (or restart) server with the `integration_test` environment. For example: `rails s -e integration_test`.


## Browsers to test on:
- [ ] IE 8+
- [ ] Firefox
- [ ] Chrome
- [ ] Safari

## Registration

### Users
1. Navigate to home page.

2. Scroll to bottom registration form.

3. **Missing form information**
   - Fill in form with the following 5 fields missing:
      - First name: `Some`
      - Last name:  `User`
      - Birth year: `1980`
      - email:      `someuser@gmail.com`
      - password:   `password`
   - Ensure error message matches missing field.
   - Ensure no form information is lost.

4. **Incorrect form information**
   - Do the following:
      - Fill in form with year 2010
      - Fill in incorrect email address format
      - Fill in password of length < 8
      - Fill in email with duplicate: `tommyboy@gmail.com`
   - Ensure error message matches error
   - Ensure no form information is lost

5.  **Successful signup flow**
   - Fill out form with the fields from above
   - Submit using `Enter` key
   - Ensure user is redirected to `get-started` path, with signed in user information showing up on the sidebar.


   - Sign out
   - Go back to homepage
   - Change email to `someuser1980@gmail.com`
   - Submit by clicking `Submit` button
   - Ensure user is redirected as stated above.

6. **Get-started flow**
   - After successful registration, user should end up on `get-started` page, with the **User Role Selection** question showing up.
   - *Without selection of user role*, click submit button.
      - Error should show up mandating user type selection.
   - **User Branch**
      - When one of the following options is selected: **A, B, C, D, F** but **E** is not selected, users should be redirected to privacy policy page.
      - A modal should welcome users to MyApnea.Org and explain the consent process.
      - On **Privacy Policy** page, users should be able to:
         - Print privacy policy with `Print Privacy Policy` button.
         - Decline the privacy policy, thereby redirecting the user to home page.
         - Accept privacy policy by clicking `I have read the privacy policy` button.
      - If privacy policy is accepted, user should be taken to **Consent** page.
      - On **Consent** page, users should be able to:
         - Print the consent.
         - Decline the consent, thereby redirecting to the home page.
         - Accept the consent, thereby redirecting to the embedded `about-me` survey.
      - If a user accepts the consent, they should fill out the `about-me` survey.
         - Survey should work as detailed in [Surveys](#Surveys) section.

   - **Provide Branch**
      - Log out and Register as a new, provider-focused user:
         - `Some Provider` with `someprovider@gmail.com`, `1980`, `password`
         - Choose options **E** on user type selection question. Note: if this multiple choice answer contains option **E**, the provider flow is selected regardless of other options.
      - User will be brought to **Terms of Access** page.
         - User can print
         - User can decline ==> provider profile
         - User can accept ==> provider profile
      - User will be shown **My Provider Profile** page.
         - See [Provider](##Provider) section for functionality.



### Providers
1. Navigate to `/providers/new`

2. Click `Create your page` button, which should scroll down to bottom of page form.

3. Fill out form, testing for missing fields and for invalid fields as specified in [User section](##Users)
   - Attributes:
      - Some
      - OtherProvider
      - someotherprovider@gmail.com
      - password
   - Make sure clicking `Sign up!` and hitting `Enter` cause the form to submit.
   - Make sure filled in data is persisted when validation fails, across both forms.
4. Provider should be redirected to the `get-started` user role question, with option **E** already selected and provider user info showing up on right nav sidebar.
   - *Potential* Pop-up should warn user if they un-check the provider option.
5. Provider will be brought to **Terms of Access** page.
   - User can print
   - User can decline ==> provider profile
   - User can accept ==> provider profile

6. Provider will be taken to **Provider Profile** page.
   - Provider should be educated about the reason for filling out the provider profile:
      - to be seen on the provider index page
      - to allow their members/patients to sign up with a custom url
   - [ ] Provider can choose a photo
   - [ ] Provider **needs to** select official name
   - [ ] Provider **needs to** select custom url. *Note: when a provider enters the provider name, the custom url should pre-populate with a slugified version of their name*
   - [ ] Provider can provider welcome message.

7. Provider should be redirected to their custom provider page on submission of form.

## Sign In

### Users (and Providers)
1. [ ] Sign out if signed in as a user.

2. [ ] Go to home page

3. [ ] **Sign in errors**
   - Password **needs to** be present and correct.
   - Email **needs to** be present and valid.
   - [ ] Ensure error is correctly handled

4. [ ] **Successful sign in**
   - Fill in email with `user_1@mail.com`, and password with `password`
   - Test with `Enter` button and `Login` click.
   - Ensure redirected to homepage and logged in

## Surveys

### Consent and Privacy
- [ ] Sign in with `user_2@mail.com`, `password` combo
- [ ] Click on `Research Surveys` in sidebar nav. This should take you to the **Privacy Policy/Consent** flow, and subsequently to **survey index page**.
- [ ] Click on one of the surveys in the dashboard survey section. This should take you to the **Privacy Policy/Consent** flow, and subsequently to **survey show page**.

#### Consent and Privacy Flow
- [ ] Privacy Policy page should show up
   - User can print
   - User can accept ==> Consent
   - User can decline ==> friendly return
- [ ] Consent shows up
   - User can print
   - User can accept ==> friendly forward
   - User can decline ==> friendly return

#### Modifications on *Account* page

##### New user that hasn't accepted consent of privacy policy
1. Sign in with `user_3@mail.com`, `password`
2. Go to `account` page
3. Two options should be visible on top of the page:
   - Review Consent
   - Review Privacy Policy
4. Things to test:
   - [ ] When user choses either option, they should be shown that page first.
   - [ ] If they have the other option unsigned, they should be shown that page after pressing `accept`.
   - [ ] If at any point they decline, they should be friendly returned.
   - [ ] If they accept both, they should be friendly forwareded.
   - [ ] If they already have one option signed, they should not be shown it after viewing the other one.
   - [ ] Buttons on account page should indicate whether either option has already been signed or not.



##### User that had already accepted both consent and privacy policy

1. Sign in with `tommyboy@gmail.com`, `password`
2. Go to `account` page
3. Summary of functionality:
- [ ] User should be able to view consent.
- [ ] User should be able to view privacy policy.
- [ ] User should be able to click `Leave Research Study`.

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




## Forum

## Rank the research



## Static Pages
Ensure each of these pages displays properly

- [ ] Landing page
- [ ] Provider Landing page
- [ ] Introduction
- [ ] Team
- [ ] Advisory Page
- [ ] Partners
- [ ] Learn
- [ ] FAQs





## Provider Index Page


## TODO Later:
### Account Settings
### Admin Dashboard
