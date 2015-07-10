Rails.application.routes.draw do

  scope module: 'home' do
    get :dashboard
    get :landing
    post :posts
  end

  resources :highlights
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Static Pages
  root 'home#dashboard'
  scope module: 'static' do
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
    get :sizes
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
  get 'get-started/step-one' => 'account#get_started_step_one'
  get 'get-started/step-two' => 'account#get_started_step_two'
  get 'get-started/step-three' => 'account#get_started_step_three'
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
  resources :providers
  get 'bwh', to: redirect("providers/bwh")

  # Facebook Real Updates
  # match "update_fb_feed", to: "posts#receive_update", as: :update_fb_feed, via: :post
  # match "verify_fb_subscription", to: "posts#verify_subscription", as: :verify_fb_subscription, via: :get

  get "members", to: "members#index", as: :members
  get "members/:forum_name", to: "members#show", as: :member
  get "members_search", to: "members#search", as: :members_search

  # Research Topics
  #match 'research_topic/:id', to: "research_topics#show", as: :research_topic, via: :get
  #match 'research_questions', to: 'research_topics#index', via: :get, as: :research_topics
  #match 'research_questions/new', to: 'research_topics#new', via: :get, as: :new_research_topic
  match 'research_topics_tab', to: "research_topics#research_topics", via: :get, as: :research_topics_ajax

  resources :research_topics, path: 'research-topics' do
    collection do
      get :intro
      get 'first-topics', as: :first_topics
      get :newest
      get 'most-discussed', as: :most_discussed
      get :all
      get 'my-research-topics', as: :my_research_topics
      # Accepted research topics
      get 'accepted', to: 'research_topics#accepted_research_topics_index', as: :accepted
    end
  end

  get 'research-topics/accepted/does-treatment-of-sleep-apnea-influence-body-weight', to: "research_topics#sleep_apnea_body_weight", as: "sleep_apnea_body_weight"
  get 'research-topics/accepted/does-sleep-influence-memory-and-brain-plasticity', to: "research_topics#sleep_apnea_brain_plasticity", as: "sleep_apnea_brain_plasticity"
  get 'research-topics/accepted/obstructive-sleep-apnea-and-adenotonsillectomy-in-children', to: "research_topics#sleep_apnea_adenotonsillectomy_children", as: "sleep_apnea_adenotonsillectomy_children"
  get 'research-topics/accepted/link-between-type-2-diabetes-and-sleep-apnea', to: "research_topics#sleep_apnea_diabetes", as: "sleep_apnea_diabetes"
  get 'research-topics/accepted/can-nighttime-oxygen-replace-cpap-for-treatment-of-sleep-apnea', to: "research_topics#sleep_apnea_nighttime_oxygen_use", as: "sleep_apnea_nighttime_oxygen_use"
  get 'research-topics/accepted/didgeridoo-a-potentially-novel-intervention-for-sleep-apnea', to: "research_topics#sleep_apnea_didgeridoo", as: "sleep_apnea_didgeridoo"

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
  get 'community', to: 'social#overview', via: :get, as: :community
  # match 'social', to: 'social#overview', via: :get, as: 'social' # show
  match 'social/profile', to: 'social#profile', as: 'social_profile', via: :get #edit
  match 'social/profile', to: 'social#update_profile', as: 'update_social_profile', via: [:put, :post, :patch] # update
  match 'locations', via: :get, as: :locations, format: :json, to: 'social#locations'
  get 'social/discussion', to: redirect("forums")
  get 'social/discussion(/*path)', to: redirect("forums/%{path}")

  # Account Section
  scope module: 'account' do
    post :suggest_random_forum_name
  end

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
  get 'admin/research-topics' => 'admin#research_topics', as: 'admin_research_topics'
  get 'admin/version-stats' => 'admin#version_stats', as: 'admin_version_stats'
  get 'admin/cross-tabs' => 'admin#cross_tabs', as: 'admin_cross_tabs'
  get 'admin/reports/location' => 'admin#location', as: 'admin_reports_location'
  get 'admin/reports/progress' => 'admin#progress_report', as: 'admin_progress_report'
  get 'admin/reports/engagement' => 'admin#engagement_report', as: 'admin_engagement_report'
  get 'admin/providers' => 'admin#providers'
  get 'admin/daily-engagement' => 'admin#daily_engagement', as: 'admin_daily_engagement'

  get 'admin/daily_engagement_data' => 'admin#daily_engagement_data', format: :json
  post 'daily-demographic-breakdown', to: 'admin#daily_demographic_breakdown', as: :daily_demographic_breakdown


  # Development/System
  get 'pprn' => 'application#toggle_pprn_cookie'

  # Questions - deprecated?
  resources :questions

  # Voting on Research Topics
  match 'vote', to: 'research_topics#vote', via: :post, as: :vote
  match 'remote-vote', to: 'research_topics#remote_vote', via: :post, as: :remote_vote
  match 'change-vote', to: 'research_topics#change_vote', via: :patch, as: :change_vote
  get 'votes', to: 'research_topics#votes'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }, path_names: { sign_up: 'join', sign_in: 'login' }, path: "/"

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

  get 'forum', to: redirect("forums")
  get 'research_surveys', to: redirect("surveys")
  get 'update_account', to: redirect("account")
  get 'change_password', to: redirect("account")
  get 'social', to: redirect("community")



  # # API
  # scope '/users' do
  #   post '/', to: 'api#user_signup'
  #   post '/', to: 'api#user_login'
  scope 'api' do
    scope '/research-topics' do
      get '/', to: 'api#research_topic_index'
      get '/votes', to: 'api#votes'
      post '/create', to: 'api#research_topic_create'
      post '/vote', to: 'api#vote'
    end
    scope '/forums' do
      get '/topics', to: 'api#topic_index'
      get '/topics/:topic_id', to: 'api#topic_show'
      post 'topics/create', to: 'api#topic_create'
      post 'posts/create', to: 'api#post_create'
    end
  end

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
