module Api
  module V1
    class MeController < BaseController
      def show
        render json: UserSerializer.new(Current.user).as_json, status: :ok
      end

      def update
        Current.user.update!(me_params)
        render json: UserSerializer.new(Current.user).as_json, status: :ok
      end

      private

      def me_params
        params.permit(:name)
      end
    end
  end
end
