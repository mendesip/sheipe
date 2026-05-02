module Api
  module V1
    class MeController < BaseController
      def show
        render json: { id: Current.user.id }, status: :ok
      end
    end
  end
end
