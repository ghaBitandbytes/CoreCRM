Rails.application.routes.draw do
  get "notifications/index"
  get "notifications/update"
  root "home#index"

  # Devise authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Static pages
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'salesmanager', to: 'salesmanager#index', as: :salesmanager_dashboard
  get "home/index"
  get "analytics", to: "analytics#analytics"
  get "analytics/lead_conversion", to: "analytics#lead_conversion", as: :analytics_lead_conversion

  
  
  # Sidekiq dashboard (admin only)
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Notifications
  resources :notifications, only: [:index, :update]

  resources :deals, only: [:index] # This allows /deals

  # Stage management (now includes :destroy)
  resources :stages, only: [:index, :edit, :update, :new, :create, :destroy]

  # Tasks and nested comments
  resources :tasks do
    resources :comments, only: [:create, :destroy]
  end

  # Companies with nested contacts, deals, and tasks
  resources :companies do
  collection do
    get 'all'
  end
  member do
    get :export_pdf  # This should be inside the companies resource block
  end

    resources :contacts, only: [:index, :new, :create]
    resources :deals, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      collection do
        get :kanban  # Company-specific kanban: /companies/:company_id/deals/kanban
      end
      patch :update_stage, on: :member
    end
    resources :tasks, only: [:new, :create, :edit, :update, :destroy]
  end

  # Standalone deals routes (for "My Deals")
  resources :deals, except: [:index] do
    collection do
      get :kanban  # Global kanban: /deals/kanban
    end
    patch :update_stage, on: :member
    resources :tasks, only: [:new, :create, :edit, :update, :destroy]
  end

  # Contacts with nested tasks
  resources :contacts, only: [:index, :show, :edit, :update, :destroy] do
    resources :tasks, only: [:new, :create, :edit, :update, :destroy]
  end

  # Leads and their reminders
  resources :leads do
    collection do
      get :export
      get :kanban
    end
    resources :reminders, only: [:create, :edit, :update, :destroy]
  end

end
