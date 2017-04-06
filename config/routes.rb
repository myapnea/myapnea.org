# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#dashboard'

  namespace :async do
    namespace :blog do
      post :login
      post :register
      post :reply
    end
    namespace :forum do
      post :login
      post :new_topic
    end
    namespace :parent do
      post :login
      post :reply
    end
  end

  namespace :admin do
    resources :replies, only: :index
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
    get :contact
    get :voting
    get :landing, path: 'sunny/landing'
  end

  scope module: :blank do
    get :menu, path: 'question/menu'
    get :yoga, path: 'mindfulness/yoga-usefulness-scale(/:id)'
    get :question, path: 'question(/:id)'
    get :sky
    get :sunset
    get :night
    get :blue
    get :orange
    get :green
    get :landing2
    get :landing3
  end

  scope module: 'home' do
    get :dashboard
    get :landing
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Static Pages
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

  resources :notifications do
    collection do
      patch :mark_all_as_read
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
  scope module: :account do
    post :suggest_random_forum_name
    delete 'account/delete', action: 'destroy', as: :delete_account
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
  get 'patient-engagement-panel-charter', to: 'static#pep_charter', as: :pep_charter

  # Admin Section
  get 'admin' => 'admin#dashboard'
  get 'admin/surveys' => 'admin#surveys', as: 'admin_surveys'
  post 'admin/unlock_survey' => 'admin#unlock_survey', as: 'admin_unlock_survey'
  get 'admin/cross-tabs' => 'admin#cross_tabs', as: 'admin_cross_tabs'
  get 'admin/reports/timeline' => 'admin#timeline', as: 'admin_reports_timeline'
  get 'admin/reports/location' => 'admin#location', as: 'admin_reports_location'
  get 'admin/reports/progress' => 'admin#progress_report', as: 'admin_progress_report'
  get 'admin/providers' => 'admin#providers'
  post 'daily-demographic-breakdown', to: 'admin#daily_demographic_breakdown', as: :daily_demographic_breakdown

  get 'admin/social-media', to: 'admin#social_media'

  devise_for :users,
             controllers: { registrations: 'registrations', sessions: 'sessions' },
             path_names: { sign_up: 'join', sign_in: 'login' },
             path: ''

  resources :users do
    collection do
      get :export
    end
    member do
      get :photo
    end
  end

  resources :topics, path: 'forum' do
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

  get 'sitemap.xml.gz' => 'external#sitemap'

  get 'update_account', to: redirect('account')
  get 'change_password', to: redirect('account')
end
