module Api
  module V1
    class WorkoutExercisesController < BaseController
      def create
        workout = Workout.find(params[:workout_id])
        authorize! workout, to: :update?
        we = workout.workout_exercises.new(workout_exercise_params.merge(exercise_id: params[:exercise_id]))
        we.save!
        render json: WorkoutExerciseSerializer.new(we).as_json, status: :created
      end

      def update
        workout = Workout.find(params[:workout_id])
        authorize! workout, to: :update?
        we = workout.workout_exercises.find(params[:id])
        we.update!(workout_exercise_params)
        render json: WorkoutExerciseSerializer.new(we).as_json, status: :ok
      end

      def destroy
        workout = Workout.find(params[:workout_id])
        authorize! workout, to: :update?
        we = workout.workout_exercises.find(params[:id])
        we.destroy!
        head :no_content
      end

      private

      def workout_exercise_params
        params.permit(:position, :notes)
      end
    end
  end
end
