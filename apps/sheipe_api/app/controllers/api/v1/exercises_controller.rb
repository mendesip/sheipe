module Api
  module V1
    class ExercisesController < BaseController
      def index
        scope = authorized_scope(Exercise.all)
        scope = scope.where(muscle_group: params[:muscle_group]) if params[:muscle_group].present?
        scope = scope.where(category: params[:category])         if params[:category].present?
        scope = scope.where("name ILIKE ?", "%#{params[:query]}%") if params[:query].present?
        scope = scope.order(:name)

        records, meta = paginate(scope)
        render json: {
          data: ExerciseSerializer.new(records).serializable_hash,
          meta: meta
        }, status: :ok
      end

      def show
        exercise = authorized_scope(Exercise.all).find(params[:id])
        authorize! exercise
        render json: ExerciseSerializer.new(exercise).as_json, status: :ok
      end

      def create
        exercise = Exercise.new(exercise_params.merge(creator: Current.user, is_system: false))
        authorize! exercise
        exercise.save!
        render json: ExerciseSerializer.new(exercise).as_json, status: :created
      end

      def update
        exercise = Exercise.find(params[:id])
        authorize! exercise
        exercise.update!(exercise_params)
        render json: ExerciseSerializer.new(exercise).as_json, status: :ok
      end

      def destroy
        exercise = Exercise.find(params[:id])
        authorize! exercise
        exercise.destroy!
        head :no_content
      end

      private

      def exercise_params
        params.permit(:name, :description, :muscle_group, :category)
      end
    end
  end
end
