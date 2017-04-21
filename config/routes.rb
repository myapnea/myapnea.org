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

  scope module: :external do
    post :preview
    get :contact
    get :landing
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
    get :activity, path: 'dashboard/activity'
    get :research, path: 'dashboard/research'
    get :reports, path: 'dashboard/reports'
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
    get :partners
  end

  get 'members', to: 'members#index', as: :members
  get 'members/:forum_name', to: 'members#show', as: :member
  get 'members/:forum_name/posts', to: 'members#posts', as: :member_posts
  get 'members/:forum_name/badges', to: 'members#badges', as: :member_badges
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

  # Admin Section
  get 'admin' => 'admin#dashboard'

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
end
