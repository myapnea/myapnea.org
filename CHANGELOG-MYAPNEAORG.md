## 3.1.0

### Enhancements
- **Home Page Changes**
  - Surveys linked on the home page have been updated to better show a member's progress through the available surveys
  - Landing page now loads for non-logged in users
- **Registration Changes**
  - Year of Birth is now a drop down list to avoid confusion between entering Birth Date instead of Year of Birth
- **Forum Changes**
  - Forum index no longer shows quoted text in forum replies
  - Improved the user interface for the forum index and the forum widget on the home page
  - Forum topics now have an updated interface that focuses on easier readability
- **General Changes**
  - Minor text and content updates throughout the site
  - Fixed an issue where long links and title would run into the page from the Recent News bar
- **Administrative Changes**
  - Administrators can export users to update MailChimp lists and segments
  - Blog posts link now correctly goes to the news forum
- **Gem Changes**
  - Updated to rails 4.2.0

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
