Rails.application.routes.draw do

  resources :engagements do
    resources :engagement_responses
  end
  resources :reactions, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  namespace :admin do
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

  namespace :builder do
    resources :surveys do
      resources :questions do
        resources :answer_templates do
          resources :answer_options
        end
      end
      resources :survey_user_types
      resources :survey_encounters
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

  scope module: 'home' do
    get :dashboard
    get :landing
    post :posts
  end

  resources :highlights do
    member do
      get :photo
    end
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

  # Educational Content
  scope 'learn' do
    get '/', to: 'static#learn'
    get '/what-is-sleep-apnea', to: 'static#what_is_sleep_apnea'
    get '/obstructive-sleep-apnea', to: 'static#obstructive_sleep_apnea'
    get '/central-sleep-apnea', to: 'static#central_sleep_apnea'
    get '/complex-sleep-apnea', to: 'static#complex_sleep_apnea'
    get '/causes-of-sleep-apnea', to: 'static#causes'
    get '/symptoms-of-sleep-apnea', to: 'static#symptoms'
    get '/risk-factors-for-sleep-apnea', to: 'static#risk_factors'
    get '/diagnosis-of-sleep-apnea', to: 'static#diagnostic_process'
    get '/treatment-options-for-sleep-apnea', to: 'static#treatment_options'
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

  # Research Topics
  resources :research_topics, path: 'research-topics' do
    collection do
      get :intro
      get 'first-topics', as: :first_topics
      get 'my-research-topics', as: :my_research_topics
      # Accepted research topics
      get 'accepted', to: 'research_topics#accepted_research_topics_index', as: :accepted
      get 'accepted/:slug', to: 'research_topics#accepted_article', as: :accepted_article
    end
  end

  # get 'research-topics/accepted/does-treatment-of-sleep-apnea-influence-body-weight', to: 'research_topics#sleep_apnea_body_weight', as: 'sleep_apnea_body_weight'
  # get 'research-topics/accepted/does-sleep-influence-memory-and-brain-plasticity', to: 'research_topics#sleep_apnea_brain_plasticity', as: 'sleep_apnea_brain_plasticity'
  # get 'research-topics/accepted/obstructive-sleep-apnea-and-adenotonsillectomy-in-children', to: 'research_topics#sleep_apnea_adenotonsillectomy_children', as: 'sleep_apnea_adenotonsillectomy_children'
  # get 'research-topics/accepted/link-between-type-2-diabetes-and-sleep-apnea', to: 'research_topics#sleep_apnea_diabetes', as: 'sleep_apnea_diabetes'
  # get 'research-topics/accepted/can-nighttime-oxygen-replace-cpap-for-treatment-of-sleep-apnea', to: 'research_topics#sleep_apnea_nighttime_oxygen_use', as: 'sleep_apnea_nighttime_oxygen_use'
  # get 'research-topics/accepted/didgeridoo-a-potentially-novel-intervention-for-sleep-apnea', to: 'research_topics#sleep_apnea_didgeridoo', as: 'sleep_apnea_didgeridoo'
  # get 'research-topics/accepted/unilateral-hypoglossal-nerve-stimulation-sleep-apnea-treatment', to: 'research_topics#sleep_apnea_hypoglossal_stimulation', as: 'sleep_apnea_hypoglossal_stimulation'
  # get 'research-topics/accepted/women-with-sleep-apnea-increased-risk-for-heart-disease-with-age', to: 'research_topics#sleep_apnea_women_heart_disease', as: 'sleep_apnea_women_heart_disease'
  # get 'research-topics/accepted/atrial-fibrillation-and-its-links-to-sleep-apnea', to: 'research_topics#sleep_apnea_afib', as: 'sleep_apnea_afib'

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
  match 'forums/terms-and-conditions', to: 'account#terms_and_conditions', via: :get, as: :terms_and_conditions

  # Social Section
  get 'community', to: 'social#overview', via: :get, as: :community
  get 'social/discussion', to: redirect('forums')
  get 'social/discussion(/*path)', to: redirect('forums/%{path}')
  get 'social/profile', to: redirect('account')
  get 'profile', to: redirect('account')

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
  get 'advisory-council-charter', to: 'static#AC_charter', as: :ac_charter

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

  # Development/System
  get 'pprn' => 'application#toggle_pprn_cookie'

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

  # Forums
  # TODO remove redirects in 8.0
  get 'forums/introductions', to: redirect('forums/general')
  get 'forums/introductions(/*path)', to: redirect('forums/general/%{path}')
  get 'forums/rank-the-research', to: redirect('forums/research')
  get 'forums/rank-the-research(/*path)', to: redirect('forums/research/%{path}')
  # get 'forums/research-topics(/*path)', to: redirect("research-%{path}")
  # end TODO from 5.1
  resources :forums do
    resources :topics do
      member do
        post :subscription
      end
      resources :posts do
        collection do
          post :preview
        end
      end
    end
    collection do
      get :markup
    end
  end

  get 'forum', to: redirect('forums')
  get 'research_surveys', to: redirect('surveys')
  get 'update_account', to: redirect('account')
  get 'change_password', to: redirect('account')
  get 'social', to: redirect('community')

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
