Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Static Pages
  root 'static#home'
  get 'home'      => 'static#home'
  get 'about'     => 'static#about'
  get 'share'     => 'static#share' # Alias of About
  get 'team'      => 'static#team'
  get 'advisory'  => 'static#advisory'
  get 'partners'  => 'static#partners'
  get 'learn'     => 'static#learn'
  get 'faqs'      => 'static#faqs'
  get 'research'  => 'static#research'
  get 'theme'     => 'static#theme'
  get 'version'   => 'static#version'
  get 'sitemap'   => 'static#sitemap'

  # Sleep Tips
  get 'sleep-tips'   => 'static#sleep_tips'

  # Registration flow
  get 'get-started' => 'account#get_started'
  get 'get-started/privacy' => 'account#get_started_privacy'
  get 'get-started/consent' => 'account#get_started_consent'
  get 'get-started/about-me' => 'account#get_started_about_me'
  get 'get-started/terms-of-access' => 'account#get_started_terms_of_access'
  get 'get-started/provider-profile' => 'account#get_started_provider_profile'
  get 'get-started/social-profile' => 'account#get_started_social_profile'

  get 'user_type' => 'account#user_type'
  patch 'set_user_type' => 'account#set_user_type'
  post 'accepts_privacy' => 'account#accepts_privacy'
  post 'accepts_consent' => 'account#accepts_consent'
  post 'accepts_terms_of_access' => 'account#accepts_terms_of_access'

  # Provider Pages
  get 'p(/:slug)', to: 'static#provider_page'
  resources :providers

  # Facebook Real Updates
  # match "update_fb_feed", to: "posts#receive_update", as: :update_fb_feed, via: :post
  # match "verify_fb_subscription", to: "posts#verify_subscription", as: :verify_fb_subscription, via: :get


  # Research Topics
  #match 'research_topic/:id', to: "research_topics#show", as: :research_topic, via: :get
  #match 'research_questions', to: 'research_topics#index', via: :get, as: :research_topics
  #match 'research_questions/new', to: 'research_topics#new', via: :get, as: :new_research_topic
  match 'research_topics_tab', to: "research_topics#research_topics", via: :get, as: :research_topics_ajax
  get 'vote_counter' => 'research_topics#vote_counter'
  resources :research_topics

  # Research Section
  get 'research_topics' => 'research#research_topics'
  get 'research_karma' => 'research#research_karma'
  get 'research_today' => 'research#research_today'
  get 'data_connections' => 'research#data_connections'

  # Surveys
  get 'surveys' => 'surveys#index', as: :surveys
  get 'surveys/example', to: 'surveys#example'
  get 'surveys/:slug/report(/:answer_session_id)', to: 'surveys#show_report', as: :survey_report
  match 'surveys/:slug', to: 'surveys#show', as: :survey, via: :get
  ## Answer Processing
  match 'research_surveys/process_answer', to: 'surveys#process_answer', via: :post, as: :process_answer
  ## JSON
  get 'questions/frequencies(/:question_id/:answer_session_id)', to: "questions#frequencies", as: :question_frequencies, format: :json
  get 'questions/typeahead/:question_id', to: "questions#typeahead", as: :question_typeahead, format: :json
  ## Deprecated - Remove in Version 6.0.0
  get 'research_surveys/:slug', to: 'surveys#start_survey', as: :start_survey
  get 'research_surveys/intro/:slug', to: 'surveys#intro', as: :intro_survey
  get 'research_surveys/:answer_session_id/:question_id', to: 'surveys#ask_question', as: :ask_question


  # Discussion
  match 'forums/terms_and_conditions', to: 'account#terms_and_conditions', via: :get, as: :terms_and_conditions

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

  match 'privacy_policy', to: "account#privacy_policy", as: :privacy, via: [:get, :post]
  match 'update_account', to: 'account#update', as: 'update_account', via: :patch
  match 'change_password', to: 'account#change_password', as: 'change_password', via: :patch

  match 'terms_of_access', to: 'account#terms_of_access', as: :terms_of_access, via: [:get, :post]

  # Admin Section
  get 'admin' => 'admin#dashboard'
  get 'admin/surveys' => 'admin#surveys', as: 'admin_surveys'
  get 'admin/notifications' => 'admin#notifications', as: 'admin_notifications'
  get 'admin/research_topics' => 'admin#research_topics', as: 'admin_research_topics'
  get 'admin/research_topic/:id' => 'admin#research_topic', as: 'admin_research_topic'

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
  end

  get 'forum', to: redirect("forums")

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
