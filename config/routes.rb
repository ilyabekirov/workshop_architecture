Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users
  root to: redirect('/admin/') # if Routing::Admin.present?
  # namespace :admin do
  #   # root to: 'home#index', as: :root

  #   # devise_options = {
  #   #   skip: :sessions,
  #   #   singular: :employee
  #   # }
  #   devise_for :admin_users
  #   # devise_for :users, controllers: {registrations: 'user/registrations', sessions: 'sessions', passwords: 'user/passwords'}, skip: :unlocks

  #   # devise_scope :employee do
  #   #   get    'login',  to: 'sessions#new'
  #   #   post   'login',  to: 'sessions#create'
  #   #   delete 'logout', to: 'sessions#destroy'
  #   # end
  # end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  resources :books, only: [ :index ] do
    get ':page', action: :index, on: :collection,
      constraints: { page: /\d+/ }, defaults: { page: nil }
  end
end
