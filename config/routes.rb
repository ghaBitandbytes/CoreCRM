Rails.application.routes.draw do
  root "home#index"

  # Devise authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Static pages
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'salesmanager', to: 'salesmanager#index', as: :salesmanager_dashboard
  get "home/index"

  # Sidekiq dashboard (admin only)
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :deals, only: [:index] # Add this line for the "My Deals" functionality
  # Stage management
  resources :stages, only: [:index, :edit, :update, :new, :create]

  resources :tasks do
    resources :comments, only: [:create, :destroy]
  end

  
# Similarly for contacts and companies
# Similarly for contacts and companies

  # Companies with nested contacts, deals, and tasks
  resources :companies do
    collection do
      get 'all'
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