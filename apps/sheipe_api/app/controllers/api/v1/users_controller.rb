module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: PublicUserSerializer.new(user).as_json, status: :ok
      end
    end
  end
end
