## 7.1.3

### Bug Fix
- Fixed an issue displaying the landing page on iOS 7 devices

## 7.1.2 (June 8, 2015)

## 7.1.1 (June 4, 2015)

### Bug Fixes
- Fixed issue with large play video overspilling on mobile landing page
- The home page no longer shows posts that have been deleted

## 7.1.0 (June 3, 2015)

### Enhancements
- **Landing Page Changes**
  - Added the new MyApnea.Org video to the landing page
  - Minor stylistic changes and user interface enhancements
  - Videos on landing and learns page now have controls enabled
  - Shortened and enhanced the intro text above the fold
  - Better explained our mission below the fold
  - Added indicator to encourage users to scroll and learn more about MyApnea
  - Moved community counter closer to the testimonial and signup form
  - Updated testimonial
- **Profile Changes**
  - Posts on member profiles now link to the exact post instead of just the topic
- **Forum Moderation Changes**
  - Forum moderators can no longer delete topics and posts
  - Spam and hidden posts now are displayed in a more consistent way for moderators
  - Site owners can now delete topics and posts
  - Moderators can now see the total number of spam topics and posts on the member's profile
- **Dashboard Changes**
  - Posts on home page now link directly to post instead of just to the topic
  - Posts on home page and on member profile pages are shown in full
  - Posts by current user will now appear on the dashboard
- **Learn Page Changes**
  - Hovering over the carousel pictures now changes the mouse pointer to a cursor to indicate that they are clickable
  - Updated YouTube link to BWH video
- **Administrative Changes**
  - Cross tabs report now displays percentages in a cleaner manner
  - Improved links back to main admin dashboard
  - Easily access social profile from user profile
  - Research topics now include links and vote count
  - Research topics can be edited
- **General Changes**
  - Updated styling for flash notification messages
  - Added standard "Open Sans" font family to ensure font consistency across devices and operating systems
- **Rank the Research Changes**
  - Voting from member profiles will not dynamically update
  - Rank the research is now publicly viewable
  - Research Highlights are now publicly viewable

### Bug Fixes
- Fixed an issue getting counts for age categories on administrative progress report
- Users cannot vote from member pages unless they have already completed the Rank the Research tutorial
- Fixed an issue with styling that allowed unwanted left/right scrolling on landing pages
- Fixed a bug where topic update notifications were sent even after a user had unsubscribed from a topic

### Refactoring
- Simplified internal role structure for setting owners and moderators

## 7.0.2 (June 2, 2015)

### Bug Fix
- Fixed URL links in password reset and account unlock emails

## 7.0.1 (June 1, 2015)

### Bug Fix
- Fixed an issue with the URL structure for Facebook and Twitter share links

## 7.0.0 (June 1, 2015)

### New Features
- **Rank the Research Overhaul**
  - Requires users to go through an intro process
    - Users will see a dedicated page that introduces and explains the feature
    - Users will then go through ten dedicated questions, one at a time
    - Users will finally be able to see the full index, which has been restyled
      - The most popular topic will be pulled above the fold to encourage further engagement
      - Endorsed questions will be shown as visual links as a proof of deliverable
      - Questions are binned by category (newest, most discussed)
      - Users can submit a question on the index page
  - Show page for each research topic includes the discussion
    - Leverages backend functionality of forums, but with custom styling and unique feel
    - Users are able to vote, and easily change their vote, from this page
  - Added a 'My Research Topics' page
    - Shows each research topic, along with its
      - Status (approved, pending review, rejected)
      - Endorsement rating
  - Added Research Highlights
    - Shows a list of approved research topics from the community
    - Each accepted question has a write up on its own separate page with unique styling, as needed
- **Dashboard**
  - Added ability for owners to dynamically update dashboard highlights
  - Added a stream of recent posts to the dashboard (continously loads all posts)
- **Profile Changes**
  - Members can drag and drop a new photo on the settings page
  - Uploaded photos are now renamed to obscure any original filename
  - Members can generate a random forum name, generated names are in the following format:
    - `AdjectiveColorAnimal####`
  - Each member has their own unique 'social profile' scoped by their forum name
    - Displays their image and overall participation stats
    - Displays all posts on the forum and approved research topics, chronologically

### Enhancements
- **Social Sharing**
  - Forum topics can now be easily shared
    - Each topic can auto generate a tweet, facebook post, and email for sharing
  - Members are able to share that they have just completed a survey after submission
- **Forum Changes**
  - Unmoderated posts are visible to users with a visible flag that they are under review
  - A disclaimer is included at the bottom of a topic with unmoderated posts
  - Members are now assigned a forum name from a list of more than 14 billion possibilities
    - Members may change their forum name in their account settings if they choose
  - Topic subscribers are now notified immediately when a new post is created
  - Editing a post now sets it back to under review for regular forum members
  - Individual posts can now have links enabled
    - Link become clickable once the post is approved
    - Members editing their post sets the post back to under review, hence removing the clickable link
  - Community member profiles have been added that show a member's popular posts and forum contributions
  - Logging in while viewing a forum or topic page now keeps the member on that page and no longer redirects to the dashboard
- **Administrative Changes**
  - Forum moderators can now get in touch with forum participants to discuss posts that may require moderation or editing
  - Added Provider Report
    - Shows the number of members who have signed up with each provider
    - Highlights the provider with the most members
  - Added Progress Report
  - Admin location report now better shows unmatched locations
- **Provider Changes**
  - Providers now receive an informational email after updating a completed provider profile
  - Member welcome emails now list their provider if they signed up through a provider page
  - The providers index can now be searched by provider name
- **General Changes**
  - Added a friendlier 404 page in case a member tries to visit a page that does not exist
  - Added retargeting pixel from Connect360 to landing page
  - Added 'Remember me' to login process to reduce landing page hits for already registered members
- **Consent Changes**
  - Updated the consent to latest approved revision
- **User Interface**
  - Updated to remove preset padding around each page
    - Maximizes screen real estate
    - Allows for more dynamic pages in the future
  - Survey module still uses interface with padding, as the surveys were optimized for this
  - Cleaned up the account page, and added easier jump-navigation
  - Cleaned up admin dashboard

### Refactoring
- Trackable links on landing page now default to local paths if the trackable link is not present
  - This allows better navigation in local and staging environments

### Bug Fixes
- Welcome modal that introduces research will only appear for nonacademic users
- Answer session is no longer required to view survey reports
- Login dropdown on top navigation optimized for internet explorer (text fields no longer spill over)
- Fixed an issue for forum moderators where topics with hidden posts would no longer be viewable on forum index
- Videos on learn page no longer cover the navigation bar when using Internet Explorer
- Improved legibility of call-out text on the landing page

## 6.1.3 (May 26, 2015)

### Bug Fix
- Fixed an issue where members could post images and links on forum without having explicit permission to post links or images

## 6.1.2 (May 12, 2015)

### Bug Fix
- Added support for JavaScript functions that were not available in Firefox and Internet Explorer

## 6.1.1 (May 1, 2015)

### Enhancements
- Temporarily removed the video from the landing page and moved to learn page
- Updated a link on the learn page
- Minor website copy changes
- Email field now gets focus when clicking the Login button in the top navigation bar
- Added bitly links to landing page for engagement tracking

### Bug Fix
- Fixed the Sleep Apnea and BMI tool not loading correctly in certain instances
- About My Family Report now properly displays the member's selected country of birth

## 6.1.0 (April 27, 2015)

### New Features
- New landing page redesign
  - Removes 'walled garden' feel by showing top navigation immediately
  - Better highlights 4 key values for possible MyApnea members

### Enhancements
- **Layout**
  - PAP devices added to learn panel
    - Minor updates to styling
    - Improved navigation between these pages
  - Navigation expanded to include distinct 'Learn' and 'Research' tabs
- **Tool Updates**
  - Updated layout of BMI calculation and graph for `Sleep Apnea and BMI` tool
  - Minor edits to wording of results on `Risk Assessment` tool
  - Minor edits to wording of results on `Sleep Apnea and BMI` tool
  - Cleaned up layout on `Risk Assessment` tool
  - Fixed minor issue with display labels for height on `Sleep Apnea and BMI` tool
- **Survey Changes**
  - Clarified wording of `family diagnostic` question in `About My Family` survey
  - Fixed a typo in the `income` question in `About Me` survey
  - Admins can now specify members to be excluded from data exports and reports
- **Forum Changes**
  - Posting on a multi-page topic now correctly loads the last topic page and post
  - Non-square member photos now display better on the forums
- **General Changes**
  - Standardized text sizes on partners page
  - ASA correctly listed as promotional partner
  - Minor copy changes throughout the site
  - Mailings that reference https://myapnea.org/bwh now forward to the BWH provider page
  - Fixed margin and spacing on FAQs
  - Privacy Policy URL now uses hyphen to be consistent with other links
- **Gem Changes**
  - Updated to Ruby 2.2.2
  - Removed slow capybara test framework
    - Tests will be handled by integration tests

### Bug Fixes
- Fixed issue with academic users not being able to see surveys
- Fixed styling on button to accept the consent and privacy policy updates

## 6.0.0 (April 15, 2015)

### New Features
- **Survey Updates**
  - Survey reports restyled to be more easily digested, and appear as infographics
    - All surveys except for 'My Interest in Research'
    - Users are able to toggle and view the original detailed reports
    - Researchers and providers are immediately shown the original reports, with option to see new reports
    - Formatting and content based on feedback sourced from members via the forums
  - System for adding custom validations for specific Survey questions
    - Date of birth validation
- **Administrative Changes**
  - Cross-Tabs admin panel added
    - Lists information about demographics of enrollment per type of referral source
  - Location breakdown admin panel added
    - Shows breakdown of member location by state and country
- **Survey Exports**
  - Common Data Model Version 2.0 exports implemented
  - ESS export task added for reporting purposes
  - PROMIS export task added for reporting purposes
  - Location Report added that shows membership by country and state
- **Public facing tools**
  - Sleep apnea risk assessment tool added
    - Based on the STOPBang survey
    - Social sharing of results added for social media
  - Sleep apnea and BMI assessment tool added
    - Transformed from BMI/AHI calculator
    - Relates sleep apnea severity to BMI category

### Enhancements
- **Gem Changes**
  - Updated to rails 4.2.1
  - Updated to redcarpet 3.2.3
- **Documentation Changes**
  - Consent and Privacy Policy updated based on need in order to do coenrollment
  - Method for users to accept this update added
    - This acceptance is required to for users to complete new surveys
    - New users will automatically accept the update when they accept the consent
  - Governance policies added to footer
- Added American Sleep Association as a partner

### Bug Fixes
- Date of birth bug fix addressed now from the backend for better handling
- Partner ISSS link updated

## 5.2.0 (March 25, 2015)

### Enhancements
- **Forum Changes**
  - Submitting a post on a topic now disables the button to prevent double-posting
  - Images in forum posts now scale correctly
- **Survey Changes**
  - Users can now toggle a simple survey display if they have trouble inputting answers

## 5.1.0 (March 13, 2015)

### New Features
- **Administrative Changes**
  - A user registration and survey completion report added
    - The report provides comparison across different MyApnea.Org releases
- **Forum Changes**
  - Posts can include mentions of other users by their social profile names
  - Topics can be searched by authors of posts within that forum
  - Moderators can now move topics between forums
- **Content Additions**
  - About Sleep Apnea
  - About PAP Therapy
  - PAP Quick Setup Guide
  - PAP Troubleshooting Guide
  - PAP Care and Maintenance
  - PAP Masks and Equipment
  - Traveling with PAP
  - Side Effects of PAP
  - Sleep Tips

### Enhancements
- Fixed some minor typos
- Social profile information is now automatically displayed after being added by member
- Providers index now properly paginates, with 12 providers listed on each page
- Forums slightly restructured
  - Introductions -> General
  - Rank the Research -> Research
  - Removed Daytime Sleepiness and Performance Outcomes
  - Removed Network Member Feedback Regarding Proposed Studies and Clinical Trials

### Bug Fixes
- Fixed a survey bug where users had incomplete multiple radio button questions locked
- Fixed a minor error generating a lottery winner
- Added redirect for deprecated 'research_surveys' to 'surveys'
- Fixed survey error when all options for a checkbox question were unselected
- Fixed incorrect answer option migration mapping for the `my-sleep-apnea` survey
- Hotkeys disabled for locked questions
- Topics with slug `new` cannot be created
- Google Analytics compatibility with Turbolinks

## 5.0.0 (March 4, 2015)

### New Features
- **Major Survey Updates**
  - Surveys have received a major update and have been restructured.
    - The three existing surveys have been split across 11 smaller surveys
  - New surveys have an exciting new interface!
    - Users are able to scroll through survey by using keystrokes
    - Answer options now have hotkeys and values
    - Animated scrolling now used to move between questions
    - Survey urls have been simplified
    - Surveys can display nested questions
    - On submission, surveys are locked, but can be reviewed when revisited
    - Surveys are assigned based on user role selected during the registration process
- **Member Roles**
  - Members are able to define one or more of the following roles:
    - Adult who has been diagnosed with sleep apnea
    - Adult who is at-risk of sleep apnea
    - Caregiver of adult diagnosed with or at-risk of sleep apnea
    - Caregiver of child(ren) diagnosed with or at-risk of sleep apnea
    - Professional care provider
    - Research professional
- **Registration Process**
  - Upon registration, users are asked to describe their role on the site
  - Upon registration, users are automatically sent through consent process
    - For providers:
      1. Privacy Policy
      2. Terms of Access
      3. Provider Profile
    - For researchers who only identify as a researcher:
      1. Privacy Policy
      2. Terms of Access
      3. Social Profile
    - For all other members:
      1. Privacy Policy
      2. Consent
      3. About Me Survey
- **Terms of Access (ToA)**
  - ToA will now be shown to the following groups, in place of the consent:
    - Members who identify as a provider, but not any patient or caregiver role
    - Members who identify as a researcher, but not any patient or caregiver role
    - Still visible by other members of the community for transparency

### Enhancements
- **Administrative Changes**
  - Added an admin dashboard to provide a central place to reach reports and research topic moderation
- **Research Study Changes**
  - Clicking "Leave Research Study" on the Consent or Privacy Policy pages now removes the member from the study
    - In the past, the member would be redirected to the account page where this question would be asked one more time
- **Forum Changes**
  - Added indication of additional posts on forum index and pagination on individual forums
  - Forum post anchors now correctly offset based on the top navigation bar
  - Forum markdown has been improved and examples are provided under the Markup tab
    - Blockquotes: `> This is quote`
    - Highlight: `==This is highlighted==`
    - Underline: `_This is underlined_`
    - Superscript: `This is the 2^(nd) time`
    - Strikethrough: `This is ~~removed~~`
- **Community Page Changes**
  - Removed state labels from USA map to provide cleaner overview
- **Lottery Updates**
  - Lottery random drawing code has been added, and can be run using `Lottery.draw_winner`
- **Search Engine Optimization**
  - Added `sitemap_generator` gem for dynamic SEO via sitemap creation
  - Added unique meta descriptions to several key pages
  - Added unique page titles to several key pages
- **Gem Changes**
  - Updated to Ruby 2.2.1

### Bug Fixes
- Password fields now display correctly in IE9
- Topic slugs are now generated correctly for topics with titles that start with numbers
- User dashboard displays correctly even without the presence of the forum

### Refactoring
- Centralized application configuration further by using figaro environment variables
- Beta UI pages are now set as the default
- Several OpenPPRN features have been disabled or removed
  - Removed OODT and Validic integration
  - Removed blog controller and views, this functionality is currently being handled by the "News Forum"
  - Removed unused `pprn.rb` initializer file
- Several survey model simplifications have been made:
  - Renamed `QuestionFlow` to `Survey`
  - Simplified survey load files
  - Answer sessions are only created when surveys are launched, and encounter identifiers
- The Forums Terms and Conditions now uses the new layout
- Reduced dependency on `authority` gem
- Cleaned up the account controller and updated tests
- Cleaned up the static controller and added appropriate tests
  - Moved `views/myapnea/static` files into `views/static` folder

## 4.2.0 (January 29, 2015)

### Enhancements
- **Provider Changes**
  - The provider sign up page now better indicates what users can do who are already signed in
    - Allows users to contact support to become a provider
    - Allows providers a link to their account settings to set up their custom pages
- **Rank the Research**
  - New UI/UX built and is now enabled for all members regardless of beta opt in status
  - Statistic shown is now percentage of voters, rather than vote count
  - Reduced complexity by displaying all data on one page (with possible need for pagination)
  - Users are able to see statistic for any questions, but will be alerted if they have used all of their votes already
- **General Changes**
  - The Privacy Policy popup now uses the identical text to the Privacy Policy page
  - Shortened the length of news posts description shown in the right hand side bar
  - Added The Health eHeart Study under Promotional Partners
  - The Partners page now uses the new layout exclusively

### Bug Fixes
- Fixed the providers "Create Your Page" button not working for logged in users
- Fixed a bug that prevented linking a provider to a newly registered user if the user ran into other registration validation errors during the sign up process
- Fixed link to CMB Solutions
- Removed link from Recent News in old layout as the page no longer exists
- Advisory member bios now open correctly on mobile devices

## 4.1.0 (January 21, 2015)

### Enhancements
- **Consent and Privacy Policy Changes**
  - **The Consent and Privacy Policy were updated to reflect the latest IRB-approved documents**
- **General Changes**
  - Minor changes to UI (links, text, sizing)
  - Fixed display of personal provider page to have fullscreen/landing layout
  - Fixed display of video and added autoplay/autopause features
  - Recent News posts now link directly back to the topics
  - Started work on allowing members to identify themselves as one of the following:
    - Diagnosed With Sleep Apnea
    - Concern That I May Have Sleep Apnea
    - Family Member of an Adult with Sleep Apnea
    - Family Member of a Child with Sleep Apnea
    - Provider
    - Researcher
- **Forum Changes**
  - Topics with posts that are pending review now show up as well when a moderator filters by topics that are pending review
  - Topics are now sorted by their last visible post, and the last post by field is also filtered by the last visible post for the user
    - Moderators will see the last post made that's pending moderation
    - Regular members will see the last approved post in the forums index
  - Moderator posts are now automatically approved
  - Post links in emails now directly reference the post and are the server will redirect these links to the correct topic page
  - Post Approval and Reply emails now reference the title of the topic so that email clients can group these together more naturally
  - Topic and Post status has been simplified to include `hidden` status, along with `approved`, `pending_review`, and `spam`
- **Community Page**
  - Added quick link to change your account settings to be included in the map
  - Community map now displays US and World membership counts
- **User Interface Changes**
  - Added user stats to side navigation bar (beta version)
  - Administrative link added into the new UI menu (beta version)
  - The terms of service, privacy policy, and consent pages have been updated to match the new UI (beta version)
  - Learn page added as a quick link beneath the 'About Us' dropdown, and updated to fit new UI (beta version)
    - Added 'additional resources' to learn page
  - SAPCON Advisory Council added as a separate page
  - Partners and promotional partners added as a separate page (removed from Our Team)
    - Industry relation text added
- **Email Changes**
  - Updated styling on Password Reset and Account Unlock emails to match new MyApnea.Org themed email layout
  - Added a new member welcome email
- **Administrative Changes**
  - Member management page has been updated and now proplery paginates members
  - Moderators can now create approved Research Topics
- **Provider Changes**
  - Providers are able to sign up with minimal information
    - Only require name, email, and password to create account
    - Will input slug, provider name, location, etc. in provider_profile page

### Bug Fixes
- Reformatted beta alerts so they would be dismissable on mobile devices
- Fixed sidebar on mobile devices
  - Now only relying on JavaScript for class changes (instead of framed animations)
  - Only using fixed-positioning for the user sidebar on medium and large screens
- Removed provider name as a field on the member registration page
- Fixed a bug that prevented topic replies from being sent out to email subscribers
- Clicking Leave the Research Study now properly reflects the member's choice on the account page

### Refactoring
- Removed all remaining `forem` gem code

## 4.0.0 (January 15, 2015)

### Enhancements
- **PCORNET Updates**
  - Added script that extracts data into the PCORNET Common Data Model 2.0
- **Forum Updates**
  - Redesigned internal forums engine
  - Posts can now be previewed before being submitted
  - Added a forum digest email
  - Members can now subscribe and unsubscribe to forum topics
    - Members receive email when a reply is made to one of their subscribed topics
  - Members can opt out of receiving forum emails in their account settings
- **General Changes**
  - Changed image sizes to speed up loading on mobile browsers
  - Members of MyApnea.Org may opt into upcoming design changes and provide feedback directly to the MyApnea.Org team
  - Readded the MyApnea.Org favicon to quickly identify the website when it is pinned in the browser
  - The new UI better handles text sizes on mobile devices
  - Links are now easier to distinguish in the new UI
- **Administrative Changes**
  - Admin Survey overview now correctly shows the number of completed surveys
  - Website roles have been simplified
- **Provider Updates**
  - Providers can now sign up and create a unique URL that they can share with their members
  - Members of MyApnea.Org can visit existing provider pages and add themselves as one of the provider members
- **Survey Changes**
  - The new UI redesign includes a new survey report overview to better display a member's survey answers compared with others

### Bug Fixes
- Confirmation boxes now properly display when deleting or removing posts

### Refactoring
- Internal `post` model changed to `notification`
  - Old `Post` class has to do with **Site Notifications** and **Blog Posts**
  - New `Post` class will be specific to **Forum Topics**

## 3.2.1 (January 8, 2015)

### Bug Fixes
- Fixed report view bug for reports with no answers
- Removed dependency on schema_plus gem

## 3.2.0 (January 8, 2015)

### Enhancements
- **Survey Changes**
  - Improved the performance and speed of surveys and survey reports

### Bug Fixes
- Fixed a bug that prevented users from progressing past question 12 in the About Me survey
- Fixed a bug preventing users from entering a date using older browsers in the About Me survey

## 3.1.0 (January 2, 2015)

### Enhancements
- **Home Page Changes**
  - New landing page added that shows total member count
    - The new landing page is the first in a series of parts of the website that will receive a user interface update
    - Landing page now loads for non-logged in users
  - Surveys linked on the home page have been updated to better show a member's progress through the available surveys
- **Registration Changes**
  - Year of Birth is now a drop down list to avoid confusion between entering Birth Date instead of Year of Birth
- **Forum Changes**
  - Forum index no longer shows quoted text in forum replies
  - Improved the user interface for the forum index and the forum widget on the home page
  - Forum topics now have an updated interface that focuses on easier readability
- **General Changes**
  - Minor text and content updates throughout the site
  - Fixed an issue where long links and title would run into the page from the Recent News bar
  - Updated timezone for forum to use Eastern Time Zone
  - Session timeout was increased to allow members to be logged out less frequently
- **Administrative Changes**
  - Administrators can export users to update MailChimp lists and segments
  - Blog posts link now correctly goes to the news forum
- **Gem Changes**
  - Updated to rails 4.2.0
  - Updated to Ruby 2.2.0

### Upcoming Changes
- Added redesign preview of the following pages:
  - Forum index page
  - About Team page
  - Survey Report page
  - Rank the Research page
  - Community Map page
  - Providers Sign Up page

### Bug Fixes
- Fixed a survey question being select one, instead of select any
- Fixed some minor spelling errors in survey questions

## 3.0.0 (December 16, 2014)

### Enhancements
- **General Changes**
  - Added lottery language to the Informed Consent to Question 14.
  - Split existing survey into three smaller surveys
  - Added new landing page prototype

## 2.1.0 (December 10, 2014)

### Enhancements
- **General Changes**
  - **In the News** integrates Facebook and forum news posts
  - Some minor text and content changes
  - Reduced size of header image to load more quickly

- **Gem Changes**
  - Updated to rails 4.2.0.rc1
  - Updated to Ruby 2.1.5

### Refactoring
- Updated production environment initialization, including integration with Figaro gem.
- The forem gem now uses the default configured email address

### Bug Fixes
- Surveys cannot be reset now without explicit permission from user.
- Added fix for Google Analytics to correctly track page views.
- Surveys with 0 answers completed can be resumed.

## 2.0.0 (November 14, 2014)

### Enhancements
- **General Changes**
  - Revamped the navigation flow.
  - Synchronized vision with OpenPPRN.
  - Cleaned up overall style.
  - Added community and personal contributions
  - Revamped forumns
  - Improved mobile navigation design
  - Added new landing page based of introduction page

## 1.1.0 (October 17, 2014)

### Enhancements
- **Research Surveys**
  - Added survey question about sleep care institutions
  - Added ASAA as a choice for how a user heard about MyApnea.
  - Implemented new question type, based on `typeahead.js`.

### Bug Fixes
- Fixed research topic voting problems encountered on Firefox browsers.
- Fixed erroneous 'true' flash message after session expiration.

## 1.0.1 (October 15, 2014)

### Enhancements
- **Sidebar Navigation**
  - Implemented collapsing sidebar for mobile users.

### Bug Fixes
- **Social Profile**
  - Fixed problem where social profile update did not save all fields.
  - Added validation for negative age values.
  - Fixed crash when uploading photo on production.
- **Research Surveys**
  - Fixed survey stability issues.
  - Cleaned up and fixed issues with survey completion report.
- **Forum**
  - Made entry into forums more obvious for users.

## 1.0.0 (October 3, 2014)

### Major Features

- **Social Profile**
  - Users can create a social profile to brand themselves on MyApnea.Org
    - Users can choose a nickname and profile picture, and choose to share their sex and age
  - Users can interact on the MyApnea.Org forums by creating new topics and posting to other users topics
  - Users can see a map of fellow users who have shared their city location

- **Research Survey**
  - Users who fill out the Research Consent form are able to fill out "About Me and My Sleep"
  - Users are provided a survey report that shows them aggregate results from others who have taken the survey

- **Rating Research Questions**
  - Users who register are able to cast votes on prominent research questions
  - Users can submit their own research questions

- **Learning about Sleep Apnea**
  - MyApnea.Org provides a "Sleep In the News" corner that allows users to read more about sleep apnea and related subjects
  - MyApnea.Org links the American Sleep Apnea Association Facebook feed to provide another resource for learning about sleep apnea

- **Administrative**
  - Administrators can assign roles to other users
  - Administrators can moderate forum posts
  - Administrators can add new blog posts for the "Sleep In the News" corner
