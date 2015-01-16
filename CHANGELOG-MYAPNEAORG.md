## 4.1.0

### Enhancements
- **General Changes**
  - Minor changes to UI (links, text, sizing)
  - Fixed display of personal provider page to have fullscreen/landing layout
  - Fixed display of video and added autoplay/autopause features
- **Forum Changes**
  - Topics with posts that are pending review now show up as well when a moderator filters by topics that are pending review
  - Topics are now sorted by their last visible post, and the last post by field is also filtered by the last visible post for the user
    - Moderators will see the last post made that's pending moderation
    - Regular members will see the last approved post in the forums index
  - Moderator posts are now automatically approved
  - Post links in emails now directly reference the post and are the server will redirect these links to the correct topic page
  - Post Approval and Reply emails now reference the title of the topic so that email clients can group these together more naturally
- **Community Page**
  - Added quick link to change your account settings to be included in the map
  - Community map now displays US and World membership counts

### Bug Fixes
- Removed provider name as a field on the member registration page
- Fixed a bug that prevented topic replies from being sent out to email subscribers

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
  - Updated to ruby 2.2.0

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
  - Updated to ruby 2.1.5

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
