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

      resources :routines, only: [ :index, :show, :create, :update, :destroy ] do
        resources :exercises, only: [ :create, :update, :destroy ],
                  controller: "routine_exercises", as: :routine_exercises do
          resources :sets, only: [ :create, :update, :destroy ],
                    controller: "routine_sets", as: :routine_sets
        end
      end

      resources :workouts, only: [ :index, :show, :create, :update, :destroy ] do
        post :finish, on: :member
        resources :exercises, only: [ :create, :update, :destroy ],
                  controller: "workout_exercises", as: :workout_exercises do
          resources :sets, only: [ :create, :update, :destroy ],
                    controller: "workout_sets", as: :workout_sets
        end
      end
    end
  end

  match "*path", to: "api/v1/base#not_found", via: :all
end
