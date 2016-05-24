# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :async do
    namespace :blog do
      post :login
      post :register
      post :reply
    end
    namespace :chapter do
      post :login
      post :register
      post :reply
    end
  end

  resources :engagements do
    resources :engagement_responses
  end
  resources :reactions, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  namespace :admin do
    resources :broadcast_comments, only: :index, path: 'blog/comments'
    resources :replies, only: :index, path: 'forum/replies'
    resources :categories
    resources :exports do
      member do
        get :file
        post :progress
      end
    end
    resources :team_members do
      member do
        get :photo
      end
      collection do
        get :order
      end
    end
    resources :partners do
      member do
        get :photo
      end
    end
    resources :clinical_trials do
      collection do
        get :order
      end
    end
    resources :research_articles do
      member do
        get :photo
        post :preview
      end
      collection do
        get :order
      end
    end
  end

  scope module: :blog do
    get :blog
    get 'blog/category/:category', action: 'blog', as: :blog_category
    get 'blog/author/:author', action: 'blog', as: :blog_author
    get 'blog/:slug', action: 'show'
    get 'blog/:year/:month/:slug', action: 'show', as: :blog_post
  end

  resources :broadcasts, path: 'editor/blog'

  resources :broadcast_comments do
    collection do
      post :preview
    end
    member do
      post :vote
    end
  end

  resources :images do
    collection do
      post :upload, action: :create_multiple
    end
  end
  get '/image/:id' => 'images#download', as: 'download_image'

  namespace :builder do
    resources :surveys do
      member do
        get :preview
      end
      resources :questions do
        collection do
          post :reorder
        end
        resources :answer_templates do
          collection do
            post :reorder
          end
          resources :answer_options do
            collection do
              post :reorder
            end
          end
        end
      end
      resources :survey_user_types
      resources :survey_encounters
      resources :survey_editors, path: 'editors'
    end
    resources :encounters

    get '', to: redirect('builder/surveys')
  end

  scope module: :coenrollment do
    get :join_health_eheart, path: 'join-health-eheart'
    get :goto_health_eheart, path: 'goto-health-eheart'
    get 'welcome-health-eheart-members(/:incoming_heh_token)', action: 'welcome_health_eheart_members', as: :welcome_health_eheart_members
    get :link_health_eheart_member
    get :congratulations_health_eheart_members, path: 'congratulations-health-eheart-members'
    patch :remove_health_eheart
  end

  get 'children/:child_id/surveys/:id/:encounter/report' => 'surveys#report', as: :child_survey_report
  get 'children/:child_id/surveys/:id/:encounter/report-detail' => 'surveys#report_detail', as: :child_survey_report_detail
  get 'children/:child_id/surveys/:id/:encounter' => 'surveys#show', as: :child_survey
  resources :children do
    member do
      post :accept_consent
    end
  end

  scope module: :external do
    post :preview
  end

  scope module: 'home' do
    get :dashboard
    get :landing
    post :posts
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Static Pages
  root 'home#dashboard'
  scope module: 'static' do
    get :about
    get :team
    get 'pep-corner', action: :pep_corner
    get 'pep-corner/:pep_id', action: :pep_corner_show, as: :pep_corner_show
    get :advisory
    get :partners
    get :faqs
    get 'clinical-trials', action: :clinical_trials
    get :version
    get :sitemap
    get :sizes
    get :learn
    get :marketing
  end

  # Redirects for Learn Pages
  # TODO: Remove on or after 1 February 2017
  get 'learn/what-is-sleep-apnea', to: redirect('blog/what-is-sleep-apnea'), as: :what_is_sleep_apnea
  get 'learn/obstructive-sleep-apnea', to: redirect('blog/obstructive-sleep-apnea'), as: :obstructive_sleep_apnea
  get 'learn/central-sleep-apnea', to: redirect('blog/central-sleep-apnea'), as: :central_sleep_apnea
  get 'learn/complex-sleep-apnea', to: redirect('blog/what-is-complex-sleep-apnea'), as: :complex_sleep_apnea
  get 'learn/causes-of-sleep-apnea', to: redirect('blog/causes-of-sleep-apnea'), as: :causes_of_sleep_apnea
  get 'learn/symptoms-of-sleep-apnea', to: redirect('blog/symptoms-of-sleep-apnea'), as: :symptoms_of_sleep_apnea
  get 'learn/risk-factors-for-sleep-apnea', to: redirect('blog/risk-factors-for-sleep-apnea'), as: :risk_factors_for_sleep_apnea
  get 'learn/diagnosis-of-sleep-apnea', to: redirect('blog/diagnosis-of-sleep-apnea'), as: :diagnosis_of_sleep_apnea
  get 'learn/treatment-options-for-sleep-apnea', to: redirect('blog/treatment-options-for-sleep-apnea'), as: :treatment_options_for_sleep_apnea
  # END END

  # Educational Content
  scope 'learn' do
    get '/', to: 'static#learn'
    get '/pap', to: 'static#pap'
    get '/pap/about-pap-therapy', to: 'static#about_pap_therapy'
    get '/pap/pap-setup-guide', to: 'static#pap_setup_guide'
    get '/pap/pap-troubleshooting-guide', to: 'static#pap_troubleshooting_guide'
    get '/pap/pap-care-and-maintenance', to: 'static#pap_care_maintenance'
    get '/pap/pap-masks-and-equipment', to: 'static#pap_masks_equipment'
    get '/pap/traveling-with-pap', to: 'static#traveling_with_pap'
    get '/pap/side-effects-of-pap', to: 'static#side_effects_pap'
  end

  # Registration flow
  get 'get-started' => 'account#get_started'
  get 'get-started/step-two' => 'account#get_started_step_two'
  get 'get-started/step-three' => 'account#get_started_step_three'

  get 'describe-yourself' => 'account#user_type'
  patch 'set_user_type' => 'account#set_user_type'
  patch 'set_user_type_and_redirect_to_account' => 'account#set_user_type_and_redirect_to_account'
  post 'accepts_privacy' => 'account#accepts_privacy'
  post 'accepts_consent' => 'account#accepts_consent'
  post 'accepts_terms_of_access' => 'account#accepts_terms_of_access'
  post 'accepts_update' => 'account#accepts_update'
  post 'accepts_terms_and_conditions' => 'account#accepts_terms_and_conditions'

  # Invites
  resources :invites do
    collection do
      get :members
      get :providers
    end
  end

  # Provider Pages
  get 'p(/:slug)', to: 'static#provider_page'
  resources :providers do
    collection do
      post :more
    end
  end
  get 'bwh', to: redirect('providers/bwh')

  get 'members', to: 'members#index', as: :members
  get 'members/:forum_name', to: 'members#show', as: :member
  get 'members_search', to: 'members#search', as: :members_search

  resources :notifications do
    collection do
      patch :mark_all_as_read
    end
  end

  # TODO: Remove redirects on or after 30 November 2016
  get 'research-topics/accepted/complex-sleep-apnea-a-patients-story', to: redirect('blog/complex-sleep-apnea-a-patient-s-story')
  get 'research-topics/accepted/complex-sleep-apnea', to: redirect('blog/complex-sleep-apnea')
  get 'research-topics/accepted/sleep-apnea-and-hearing-loss', to: redirect('blog/sleep-apnea-and-hearing-loss')
  get 'research-topics/accepted/sleep-apnea-chronic-peridontitis-tmd', to: redirect('blog/research-links-sleep-apnea-with-both-chronic-peridontitis-and-painful-tmd-tempomandibular-disorder')
  get 'research-topics/accepted/new-frontiers-in-the-treatment-of-sleep-apnea-unilateral-hypoglossal-nerve-stimulation', to: redirect('blog/new-frontiers-in-the-treatment-of-sleep-apnea-unilateral-hypoglossal-nerve-stimulation')
  get 'research-topics/accepted/does-sleep-influence-memory-and-brain-plasticity', to: redirect('blog/does-sleep-influence-memory-and-brain-plasticity')
  get 'research-topics/accepted/obstructive-sleep-apnea-and-adenotonsillectomy-in-children', to: redirect('blog/obstructive-sleep-apnea-and-adenotonsillectomy-in-children')
  get 'research-topics/accepted/Atrial-fibrillation-and-its-links-to-sleep-apnea', to: redirect('blog/atrial-fibrillation-and-its-links-to-sleep-apnea')
  get 'research-topics/accepted/does-treatment-of-sleep-apnea-influence-body-weight', to: redirect('blog/does-treatment-of-sleep-apnea-influence-body-weight')
  get 'research-topics/accepted/what-is-the-link-between-type-2-diabetes-and-obstructive-sleep-apnea', to: redirect('blog/what-is-the-link-between-type-2-diabetes-and-obstructive-sleep-apnea')
  get 'research-topics/accepted/didgeridoos-a-potentially-novel-intervention-for-sleep-apnea', to: redirect('blog/didgeridoos-a-potentially-novel-intervention-for-sleep-apnea')
  get 'research-topics/accepted/can-nighttime-oxygen-use-replace-CPAP-for-treatment-of-sleep-apnea', to: redirect('blog/can-nighttime-oxygen-use-replace-cpap-for-treatment-of-sleep-apnea')
  get 'research-topics/accepted/new-study-shows-women-with-sleep-apnea-at-increased-risk-for-heart-disease-as-they-age', to: redirect('blog/women-sleep-apnea-and-heart-disease')
  get 'research-topics/accepted', to: redirect('blog/category/research')
  # END TODO

  # Research Topics
  resources :research_topics, path: 'research-topics' do
    collection do
      get :intro
      get 'first-topics', as: :first_topics
      get 'my-research-topics', as: :my_research_topics
      # Accepted research topics
      get 'accepted/:slug', to: 'research_topics#accepted_article', as: :accepted_article
    end
  end

  scope module: :search do
    get :search, action: 'index', as: :search
  end

  # Surveys
  resources :surveys do
    collection do
      post :process_answer
      post :submit
    end
    member do
      get '(/:encounter)/report', action: 'report', as: :report
      get '(/:encounter)', action: 'show', as: :show
      get '(/:encounter)/report-detail', action: 'report_detail', as: :report_detail
      get ':encounter/accept-update-first(/:child_id)', action: :accept_update_first, as: :accept_update_first
    end
  end

  ## Public Tools
  get 'sleep-apnea-risk-assessment' => 'tools#risk_assessment'
  post 'sleep-apnea-risk-assessment/results' => 'tools#risk_assessment_results'
  get 'sleep-apnea-risk-assessment/results' => 'tools#risk_assessment_results_display'
  # Tools
  get 'sleep-apnea-and-bmi' => 'tools#bmi_ahi'

  # Discussion
  get 'terms-and-conditions', to: 'account#terms_and_conditions', as: :terms_and_conditions

  # Social Section
  get 'community', to: 'social#overview', via: :get, as: :community

  # Account Section
  scope module: 'account' do
    post :suggest_random_forum_name
    patch :update_from_engagements
  end

  get 'account' => 'account#account'
  get 'account_export' => 'account#account_export'
  match 'consent', to: 'account#consent', as: :consent, via: [:get, :post]
  post 'revoke_consent' => 'account#revoke_consent'

  match 'privacy-policy', to: 'account#privacy_policy', as: :privacy, via: [:get, :post]
  match 'update_account', to: 'account#update', as: 'update_account', via: :patch
  match 'change_password', to: 'account#change_password', as: 'change_password', via: :patch

  match 'terms-of-access', to: 'account#terms_of_access', as: :terms_of_access, via: [:get, :post]

  # Governance
  get 'governance-policy', to: 'static#governance_policy', as: :governance_policy
  get 'patient-engagement-panel-charter', to: 'static#PEP_charter', as: :pep_charter

  # Admin Section
  get 'admin' => 'admin#dashboard'
  get 'admin/surveys' => 'admin#surveys', as: 'admin_surveys'
  post 'admin/unlock_survey' => 'admin#unlock_survey', as: 'admin_unlock_survey'
  get 'admin/research-topics' => 'admin#research_topics', as: 'admin_research_topics'
  get 'admin/cross-tabs' => 'admin#cross_tabs', as: 'admin_cross_tabs'
  get 'admin/reports/timeline' => 'admin#timeline', as: 'admin_reports_timeline'
  get 'admin/reports/location' => 'admin#location', as: 'admin_reports_location'
  get 'admin/reports/progress' => 'admin#progress_report', as: 'admin_progress_report'
  get 'admin/reports/reactions' => 'admin#reactions', as: 'admin_reactions'
  get 'admin/providers' => 'admin#providers'
  get 'admin/daily-engagement' => 'admin#daily_engagement', as: 'admin_daily_engagement'

  get 'admin/daily_engagement_data' => 'admin#daily_engagement_data', format: :json
  post 'daily-demographic-breakdown', to: 'admin#daily_demographic_breakdown', as: :daily_demographic_breakdown

  get 'admin/social-media', to: 'admin#social_media'

  # Voting on Research Topics
  match 'vote', to: 'research_topics#vote', via: :post, as: :vote
  match 'remote-vote', to: 'research_topics#remote_vote', via: :post, as: :remote_vote
  match 'change-vote', to: 'research_topics#change_vote', via: :patch, as: :change_vote

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }, path_names: { sign_up: 'join', sign_in: 'login' }, path: ''

  resources :users do
    collection do
      get :export
    end
    member do
      get :photo
    end
  end

  resources :topics do
    collection do
      get :markup
    end
    member do
      post :subscription
    end
    resources :posts do
      collection do
        post :preview
      end
    end
  end

  resources :chapters, path: 'forum' do
    member do
      get '/edit', action: :edit, as: :edit
      get '/:page', action: :show, as: :page
    end
  end

  resources :replies do
    collection do
      post :preview
    end
    member do
      post :vote
    end
  end

  get 'forums/:category/topics/*path', to: redirect('forum/%{path}')
  get 'forums/:category', to: redirect('forum')
  get 'forums', to: redirect('forum')

  get 'update_account', to: redirect('account')
  get 'change_password', to: redirect('account')

  namespace :api do
    namespace :v1 do
      resources :topics do
        resources :posts
      end
      resources :research_topics do
        collection do
          post :vote
        end
      end
      resources :surveys do
        collection do
          get :answer_sessions
          post :process_answer
          post :lock_answer_session
        end
        member do
          get :show
        end
      end
      scope module: :account do
        get 'account/home', action: :home
        get 'account/dashboard', action: :dashboard
        get 'account/photo', action: :photo
        get 'account/forum_name', action: :forum_name
        get 'account/user_types', action: :user_types
        post 'account/set_user_types', action: :set_user_types
        get 'account/ready_for_research', action: :ready_for_research
        post 'account/accept_consent', action: :accept_consent
        post 'account/set_dob', action: :set_dob
        post 'account/set_height_weight', action: :set_height_weight
        get 'account/check_dob', action: :check_dob
        get 'account/check_height_weight', action: :check_height_weight
      end
    end
  end
end
