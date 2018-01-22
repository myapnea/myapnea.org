# frozen_string_literal: true

Rails.application.routes.draw do
  root "external#landing"

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
    get :spam_inbox, path: "spam-inbox"
    post :unspamban, path: "unspamban/:id"
    post :empty_spam, path: "empty-spam"
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
    get "blog/category/:category", action: "blog", as: :blog_category
    get "blog/author/:author", action: "blog", as: :blog_author
    get "blog/:slug", action: "show"
    get "blog/:year/:month/:slug", action: "show", as: :blog_post
  end

  resources :broadcasts, path: "editor/blog"

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
  get "/image/:id" => "images#download", as: "download_image"

  scope module: :external do
    post :preview
    get :about
    get "articles/:slug", action: "article", as: :article
    get :contact
    get :landing
    get :partners
    get :privacy_policy, path: "privacy-policy"
    get :sitemap_xml, path: "sitemap.xml.gz"
    get :team
    get :voting
    get :version
  end

  scope module: :blank do
    get :menu, path: "question/menu"
    get :yoga, path: "mindfulness/yoga-usefulness-scale(/:id)"
    get :question, path: "question(/:id)"
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
    get :reports, path: "dashboard/reports"
    get :timeline
    get :yoga_consent, path: "yoga/consent"
    get :settings
    # get :settings_account, path: "settings/account"
    get :settings_consents, path: "settings/consents"
    # get :settings_emails, path: "settings/emails"
    # get :settings_profile, path: "settings/profile"
  end

  resources :projects do
    member do
      get :consent
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "members", to: "members#index", as: :members

  resources :members do
    member do
      get :profile_picture
      get :badges
      get :posts
    end
  end

  resources :notifications do
    collection do
      patch :mark_all_as_read
    end
  end

  scope module: :search do
    get :search, action: "index", as: :search
  end

  get :settings, to: redirect("settings/profile")
  namespace :settings do
    get :profile
    patch :update_profile, path: "profile"
    get :profile_picture, path: "profile/picture", to: redirect("settings/profile")
    patch :update_profile_picture, path: "profile/picture"

    get :account
    patch :update_account, path: "account"
    get :password, to: redirect("settings/account")
    patch :update_password, path: "password"
    delete :destroy, path: "account", as: "delete_account"

    get :email
    patch :update_email, path: "email"
  end

  get "surveys", to: redirect("research"), as: :surveys
  namespace :slice, path: "" do # OR: scope module: :slice
    get :research
    get :print_consent, path: "research/:project/consent.pdf"
    get :consent, path: "research/:project/consent"
    post :enrollment_consent, path: "research/:project/consent"
    get :enrollment_exit, path: "research/:project/exit"
    get :overview, path: "research/:project/overview"
    get :overview_report, path: "research/:project/overview-report"
    get :leave_study, path: "research/:project/leave-study"
    post :submit_leave_study, path: "research/:project/leave-study"

    get :surveys, path: "surveys/:project", to: "surveys#surveys"

    namespace :surveys do
      get :start, path: ":project/:event/:design/start"
      get :resume, path: ":project/:event/:design/resume"
      get :complete, path: ":project/:event/:design/complete"
      get :report, path: ":project/:event/:design/report"
      get :page, path: ":project/:event/:design/:page"
      patch :submit_page, path: ":project/:event/:design/:page"
    end
  end

  namespace :slice do
    resources :subjects
  end

  # Admin Section
  get "admin" => "admin#dashboard"

  devise_for :users,
             controllers: {
              passwords: "passwords",
              registrations: "registrations",
              sessions: "sessions",
              unlocks: "unlocks"
             },
             path_names: { sign_up: "join", sign_in: "login" },
             path: ""

  resources :users do
    collection do
      get :export
    end
  end

  resources :topics, path: "forum" do
    member do
      get "/edit", action: :edit, as: :edit
      get "/:page", action: :show, as: :page
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
  get "/providers(/:slug)", to: redirect("landing")
  # END TODO
end
