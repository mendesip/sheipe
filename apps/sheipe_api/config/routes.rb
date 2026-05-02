Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :register, to: "registrations#create"
        post :login, to: "sessions#create"
        post :refresh, to: "refreshes#create"
        delete :logout, to: "sessions#destroy"
      end

      resource :me, only: [ :show, :update ], controller: "me"
      resources :users, only: [ :show ]
      resources :exercises, only: [ :index, :show, :create, :update, :destroy ]
    end
  end

  match "*path", to: "api/v1/base#not_found", via: :all
end
