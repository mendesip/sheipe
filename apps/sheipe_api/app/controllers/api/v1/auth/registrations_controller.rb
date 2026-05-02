module Api
  module V1
    module Auth
      class RegistrationsController < BaseController
        skip_before_action :authenticate

        def create
          user = User.new(registration_params)
          user.save!
          session = user.sessions.create!
          render json: {
            access_token: session.access_token,
            refresh_token: session.refresh_token,
            user: UserSerializer.new(user).as_json
          }, status: :created
        end

        private

        def registration_params
          params.permit(:name, :email, :password, :password_confirmation, :role)
        end
      end
    end
  end
end
