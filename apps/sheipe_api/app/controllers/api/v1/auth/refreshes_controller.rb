module Api
  module V1
    module Auth
      class RefreshesController < BaseController
        skip_before_action :authenticate

        def create
          session = Session.find_by(refresh_token: params[:refresh_token])

          if session.nil? || session.refresh_token_expires_at < Time.current
            render_error("unauthorized", "Unauthorized", nil, :unauthorized)
            return
          end

          session.rotate_access_token!
          render json: { access_token: session.access_token }, status: :ok
        end
      end
    end
  end
end
