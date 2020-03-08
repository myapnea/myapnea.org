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
    get :spam_report, path: "spam-report(/:year)"
    get :profile_review, path: "profile-review"
    get :searches
    post :submit_profile_review, path: "profile-review"
    post :unspamban, path: "unspamban/:id"
    post :destroy_spammer, path: "empty-spam/:id"
    post :empty_spam, path: "empty-spam"
    resources :categories
    resources :exports do
      member do
        get :download
        post :progress
      end
    end
    resources :team_members, path: "team-members" do
      collection do
        get :order
        post :order, action: "update_order"
      end
    end
    resources :partners
  end

  get "learn", to: redirect("education")
  get "education", to: "blog#blog", category: "education"
  get "faqs", to: "blog#blog", category: "faqs"

  scope module: :blog do
    get :blog
    get "blog/category/:category", action: "blog", as: :blog_category
    get "blog/author/:author", action: "blog", as: :blog_author
    get "blog/:slug", action: "show", as: :blog_slug
    get "blog/:slug/cover", action: "cover", as: :blog_cover
    get "blog/:year/:month/:slug", action: "show", as: :blog_post
  end

  resources :broadcasts, path: "editor/blog"

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
    post "articles/:slug/vote", action: "article_vote", as: :article_vote
    get :contact
    get :consent
    get :landing
    get :partners
    get :partner_photo, path: "partners/:id/photo"
    get :privacy_policy, path: "privacy-policy"
    get :sitemap_xml, path: "sitemap.xml.gz"
    get :team
    get :team_member_photo, path: "team/:id/photo"
    get :terms_of_access, path: "terms-of-access"
    get :terms_and_conditions, path: "terms-and-conditions"
    get :voting
    get :version
  end

  scope module: :internal do
    get :dashboard
    get :timeline
    get :settings
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

    get :notifications
    patch :update_notifications, path: "notifications"
  end

  get "surveys", to: redirect("research"), as: :surveys
  namespace :slice, path: "" do # OR: scope module: :slice
    get :research
    get :print_consent, path: "research/:project/consent.pdf"
    get :consent, path: "research/:project/consent"
    post :enrollment_consent, path: "research/:project/consent"
    get :enrollment_exit, path: "research/:project/exit"
    get :overview, path: "research/:project/overview"
    get :print_overview_report, path: "research/:project/overview-report.pdf"
    get :overview_report, path: "research/:project/overview-report"
    get :leave_study, path: "research/:project/leave-study"
    post :submit_leave_study, path: "research/:project/leave-study"

    get :surveys, path: "surveys/:project", to: "surveys#surveys"

    namespace :surveys do
      get :start, path: ":project/:event/:design/start"
      get :resume, path: ":project/:event/:design/resume"
      get :review, path: ":project/:event/:design/review"
      post :complete, path: ":project/:event/:design/review"
      get :report, path: ":project/:event/:design/report"
      get :page, path: ":project/:event/:design/:page"
      patch :submit_page, path: ":project/:event/:design/:page"
    end
  end

  get :participate, path: "research/:project/participate", to: "participate#participate"

  # Admin Section
  get "admin" => "admin#dashboard"

  devise_for :users,
             controllers: {
               confirmations: "confirmations",
               passwords: "passwords",
               registrations: "registrations",
               sessions: "sessions",
               unlocks: "unlocks"
             },
             path_names: { sign_up: "join", sign_in: "login" },
             path: ""

  resources :users do
    member do
      post :spam
    end
  end

  resources :topics, path: "forum" do
    member do
      post :subscription
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
end
