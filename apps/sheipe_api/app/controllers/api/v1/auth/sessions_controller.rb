module Api
  module V1
    module Auth
      class SessionsController < BaseController
        skip_before_action :authenticate, only: [ :create ]

        def create
          user = User.find_by("lower(email) = lower(?)", params[:email])
          if user&.authenticate(params[:password])
            session = user.sessions.create!
            render json: {
              access_token: session.access_token,
              refresh_token: session.refresh_token,
              user: UserSerializer.new(user).as_json
            }, status: :ok
          else
            render_error("unauthorized", "Invalid email or password", nil, :unauthorized)
          end
        end

        def destroy
          Current.session.destroy!
          head :no_content
        end

        private

        def session_params
          params.permit(:email, :password)
        end
      end
    end
  end
end
