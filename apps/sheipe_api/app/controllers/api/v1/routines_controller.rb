module Api
  module V1
    class RoutinesController < BaseController
      def index
        scope = authorized_scope(Routine.all).order(created_at: :desc)
        records, meta = paginate(scope)
        render json: {
          data: RoutineSerializer.new(records).serializable_hash,
          meta: meta
        }, status: :ok
      end

      def show
        routine = Routine.find(params[:id])
        authorize! routine
        render json: RoutineSerializer.new(routine).as_json, status: :ok
      end

      def create
        routine = Current.user.routines.new(routine_params)
        authorize! routine
        routine.save!
        render json: RoutineSerializer.new(routine).as_json, status: :created
      end

      def update
        routine = Routine.find(params[:id])
        authorize! routine
        routine.update!(routine_params)
        render json: RoutineSerializer.new(routine).as_json, status: :ok
      end

      def destroy
        routine = Routine.find(params[:id])
        authorize! routine
        routine.destroy!
        head :no_content
      end

      private

      def routine_params
        params.permit(:name, :description, :is_template)
      end
    end
  end
end
