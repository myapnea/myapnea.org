# frozen_string_literal: true

Rails.application.routes.draw do
  root 'external#landing'

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
    get :community
    get :consent
    get :contact
    get :faqs
    get :landing
    get :privacy, path: 'privacy-policy'
    get :terms_and_conditions, path: 'terms-and-conditions'
    get :terms_of_access, path: 'terms-of-access'
    get :voting
    get :version
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
    get :landing1
    get :landing2
    get :landing3
    get :landing4
    get :landing5
    get :landing6
  end

  scope module: :internal do
    get :dashboard
    get :dashboard1
    get :dashboard2
    get :dashboard3
    get :dashboard4
    get :dashboard5
    get :timeline
    get :yoga_consent, path: 'yoga/consent'
    get :research, path: 'dashboard/research'
    get :settings
    get :settings_account, path: 'settings/account'
    get :settings_consents, path: 'settings/consents'
    get :settings_emails, path: 'settings/emails'
    get :settings_profile, path: 'settings/profile'
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
    get 'clinical-trials', action: :clinical_trials
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

  post 'accepts_privacy' => 'account#accepts_privacy'
  post 'accepts_consent' => 'account#accepts_consent'
  post 'accepts_terms_of_access' => 'account#accepts_terms_of_access'
  post 'accepts_update' => 'account#accepts_update'
  post 'accepts_terms_and_conditions' => 'account#accepts_terms_and_conditions'

  get 'members', to: 'members#index', as: :members
  get 'members/:forum_name', to: 'members#show', as: :member
  scope module: :members do
    get '/photo/:forum_name', action: 'photo', as: :photo_member
  end

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

  # Account Section
  scope module: :account do
    post :suggest_random_forum_name
    delete 'account/delete', action: 'destroy', as: :delete_account
  end

  get 'account' => 'account#account'
  get 'account_export' => 'account#account_export'
  post 'revoke_consent' => 'account#revoke_consent'

  match 'update_account', to: 'account#update', as: 'update_account', via: :patch
  match 'change_password', to: 'account#change_password', as: 'change_password', via: :patch

  # Governance
  get 'governance-policy', to: 'static#governance_policy', as: :governance_policy
  get 'patient-engagement-panel-charter', to: 'static#pep_charter', as: :pep_charter

  # Admin Section
  get 'admin' => 'admin#dashboard'
  get 'admin/surveys' => 'admin#surveys', as: 'admin_surveys'
  post 'admin/unlock_survey' => 'admin#unlock_survey', as: 'admin_unlock_survey'
  get 'admin/cross-tabs' => 'admin#cross_tabs', as: 'admin_cross_tabs'
  get 'admin/reports/timeline' => 'admin#timeline', as: 'admin_reports_timeline'
  get 'admin/reports/progress' => 'admin#progress_report', as: 'admin_progress_report'
  post 'daily-demographic-breakdown', to: 'admin#daily_demographic_breakdown', as: :daily_demographic_breakdown

  devise_for :users,
             controllers: { registrations: 'registrations', sessions: 'sessions' },
             path_names: { sign_up: 'join', sign_in: 'login' },
             path: ''

  resources :users do
    collection do
      get :export
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

  # TODO: Remove redirect after November 1, 2017
  get '/providers(/:slug)', to: redirect('landing')
  # END TODO

  get 'sitemap.xml.gz' => 'external#sitemap'

  get 'update_account', to: redirect('account')
  get 'change_password', to: redirect('account')
end
