Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resource :me, only: [ :show ], controller: "me"
    end
  end

  match "*path", to: "api/v1/base#not_found", via: :all
end
