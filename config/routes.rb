Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Static Pages
  root 'static#home'
  scope module: 'static' do
    get :landing
    get :home
    get :about
    get :team
    get :advisory
    get :partners
    get :learn
    get :faqs
    get :research
    get :theme
    get :version
    get :sitemap
  end

  # Educational Content
  get 'learn/obstructive-sleep-apnea' => 'static#obstructive_sleep_apnea'
  get 'learn/pap' => 'static#pap'
  get 'learn/pap/about-PAP-therapy' => 'static#about_PAP_therapy'
  get 'learn/pap/PAP-setup-guide'   => 'static#PAP_setup_guide'
  get 'learn/pap/PAP-troubleshooting-guide' => 'static#PAP_troubleshooting_guide'
  get 'learn/pap/PAP-care-and-maintenance' => 'static#PAP_care_maintenance'
  get 'learn/pap/PAP-masks-and-equipment' => 'static#PAP_masks_equipment'
  get 'learn/pap/traveling-with-PAP' => 'static#traveling_with_PAP'
  get 'learn/pap/side-effects-of-PAP' => 'static#side_effects_PAP'
  get 'learn/sleep-tips'   => 'static#sleep_tips'

  # Registration flow
  get 'get-started' => 'account#get_started'
  get 'get-started/privacy' => 'account#get_started_privacy'
  get 'get-started/consent' => 'account#get_started_consent'
  get 'get-started/about-me' => 'account#get_started_about_me'
  get 'get-started/terms-of-access' => 'account#get_started_terms_of_access'
  get 'get-started/provider-profile' => 'account#get_started_provider_profile'
  get 'get-started/social-profile' => 'account#get_started_social_profile'

  get 'describe-yourself' => 'account#user_type'
  patch 'set_user_type' => 'account#set_user_type'
  patch 'set_user_type_and_redirect_to_account' => 'account#set_user_type_and_redirect_to_account'
  post 'accepts_privacy' => 'account#accepts_privacy'
  post 'accepts_consent' => 'account#accepts_consent'
  post 'accepts_terms_of_access' => 'account#accepts_terms_of_access'
  post 'accepts_update' => 'account#accepts_update'

  # Provider Pages
  get 'p(/:slug)', to: 'static#provider_page'
  resources :providers
  get 'bwh', to: redirect("providers/bwh")

  # Facebook Real Updates
  # match "update_fb_feed", to: "posts#receive_update", as: :update_fb_feed, via: :post
  # match "verify_fb_subscription", to: "posts#verify_subscription", as: :verify_fb_subscription, via: :get


  # Research Topics
  #match 'research_topic/:id', to: "research_topics#show", as: :research_topic, via: :get
  #match 'research_questions', to: 'research_topics#index', via: :get, as: :research_topics
  #match 'research_questions/new', to: 'research_topics#new', via: :get, as: :new_research_topic
  match 'research_topics_tab', to: "research_topics#research_topics", via: :get, as: :research_topics_ajax
  resources :research_topics, path: 'research-topics' do
    collection do
      get :intro
      get "first-topics", as: :first_topics
      get :newest
      get "most-discussed", as: :most_discussed
      get :all
    end
  end

  # Surveys
  resources :surveys do
    collection do
      post :process_answer
      post :submit
    end
    member do
      get :report
      get 'report-detail', as: :report_detail
      get 'accept-update-first', as: :accept_update_first
    end
  end
  get 'surveys/my-health-conditions/my_health_conditions_data' => 'surveys#my_health_conditions_data', format: :json

  ## JSON
  get 'questions/frequencies(/:question_id/:answer_session_id)', to: "questions#frequencies", as: :question_frequencies, format: :json
  get 'questions/typeahead/:question_id', to: "questions#typeahead", as: :question_typeahead, format: :json


  ## Public Tools
  get 'sleep-apnea-risk-assessment' => 'tools#risk_assessment'
  post 'sleep-apnea-risk-assessment/results' => 'tools#risk_assessment_results'
  get 'sleep-apnea-risk-assessment/results' => 'tools#risk_assessment_results_display'
  # Tools
  get 'sleep-apnea-and-bmi' => 'tools#bmi_ahi'

  # Discussion
  match 'forums/terms-and-conditions', to: 'account#terms_and_conditions', via: :get, as: :terms_and_conditions

  # Social Section
  match 'social', to: 'social#overview', via: :get, as: 'social' # show
  match 'social/profile', to: 'social#profile', as: 'social_profile', via: :get #edit
  match 'social/profile', to: 'social#update_profile', as: 'update_social_profile', via: [:put, :post, :patch] # update
  match 'locations', via: :get, as: :locations, format: :json, to: 'social#locations'
  get 'social/discussion', to: redirect("forums")
  get 'social/discussion(/*path)', to: redirect("forums/%{path}")

  # Account Section
  get 'account' => 'account#account'
  get 'account_export' => 'account#account_export'
  match 'consent', to: "account#consent", as: :consent, via: [:get, :post]
  post 'revoke_consent' => 'account#revoke_consent'

  match 'privacy-policy', to: "account#privacy_policy", as: :privacy, via: [:get, :post]
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
  get 'admin/notifications' => 'admin#notifications', as: 'admin_notifications'
  get 'admin/research-topics' => 'admin#research_topics', as: 'admin_research_topics'
  get 'admin/research-topic/:id' => 'admin#research_topic', as: 'admin_research_topic'
  get 'admin/version-stats' => 'admin#version_stats', as: 'admin_version_stats'
  get 'admin/cross-tabs' => 'admin#cross_tabs', as: 'admin_cross_tabs'
  get 'admin/reports/location' => 'admin#location', as: 'admin_reports_location'
  get 'admin/providers' => 'admin#providers'

  # Development/System
  get 'pprn' => 'application#toggle_pprn_cookie'

  # Voting on Questions
  resources :questions
  match 'vote', to: 'votes#vote', via: :post, as: :vote
  match 'vote', to: 'research_topics#index', via: :get, as: :vote_fake

  # Notification Posts
  resources :notifications, except: [:show, :index]

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    collection do
      get :export
    end
  end

  # Forums
  # TODO remove redirects in 8.0
  get 'forums/introductions', to: redirect("forums/general")
  get 'forums/introductions(/*path)', to: redirect("forums/general/%{path}")
  get 'forums/rank-the-research', to: redirect("forums/research")
  get 'forums/rank-the-research(/*path)', to: redirect("forums/research/%{path}")
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

  get 'forum', to: redirect("forums")
  get 'research_surveys', to: redirect("surveys")

# # Authentication
#   devise_for :user, skip: [:sessions, :passwords, :confirmations, :registrations]
#   as :user do
#     # session handling
#     get     '/login'  => 'devise/sessions#new',     as: 'new_user_session'
#     post    '/login'  => 'devise/sessions#create',  as: 'user_session'
#     delete  '/logout' => 'devise/sessions#destroy', as: 'destroy_user_session'

#     # joining
#     # get   '/join' => 'devise/registrations#new',    as: 'new_user_registration'
#     # post  '/join' => 'devise/registrations#create', as: 'user_registration'

#     # scope '/account' do
#     #   # password reset
#     #   get   '/reset-password'        => 'devise/passwords#new',    as: 'new_user_password'
#     #   put   '/reset-password'        => 'devise/passwords#update', as: 'user_password'
#     #   post  '/reset-password'        => 'devise/passwords#create'
#     #   get   '/reset-password/change' => 'devise/passwords#edit',   as: 'edit_user_password'

#     #   # confirmation
#     #   get   '/confirm'        => 'devise/confirmations#show',   as: 'user_confirmation'
#     #   post  '/confirm'        => 'devise/confirmations#create'
#     #   get   '/confirm/resend' => 'devise/confirmations#new',    as: 'new_user_confirmation'

#     #   # settings & cancellation
#     #   get '/cancel'   => 'devise/registrations#cancel', as: 'cancel_user_registration'
#     #   get '/settings' => 'devise/registrations#edit',   as: 'edit_user_registration'
#     #   put '/settings' => 'devise/registrations#update'

#     #   # account deletion
#     #   delete '' => 'devise/registrations#destroy', as: 'destroy_user_registration'
#     # end
#   end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
