module Api
  module V1
    class WorkoutSetsController < BaseController
      def create
        we = parent_workout_exercise
        set = we.workout_sets.new(workout_set_params)
        set.save!
        render json: WorkoutSetSerializer.new(set).as_json, status: :created
      end

      def update
        we = parent_workout_exercise
        set = we.workout_sets.find(params[:id])
        set.update!(workout_set_params)
        render json: WorkoutSetSerializer.new(set).as_json, status: :ok
      end

      def destroy
        we = parent_workout_exercise
        set = we.workout_sets.find(params[:id])
        set.destroy!
        head :no_content
      end

      private

      def parent_workout_exercise
        workout = Workout.find(params[:workout_id])
        authorize! workout, to: :update?
        workout.workout_exercises.find(params[:workout_exercise_id])
      end

      def workout_set_params
        params.permit(:set_number, :weight, :reps, :rpe, :completed, :notes)
      end
    end
  end
end
