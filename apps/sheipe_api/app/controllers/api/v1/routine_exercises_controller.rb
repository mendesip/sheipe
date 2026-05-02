module Api
  module V1
    class RoutineExercisesController < BaseController
      def create
        routine = Routine.find(params[:routine_id])
        authorize! routine, to: :update?

        exercise = visible_exercise(params[:exercise_id])
        re = routine.routine_exercises.new(routine_exercise_params.merge(exercise: exercise))
        re.save!
        render json: RoutineExerciseSerializer.new(re).as_json, status: :created
      end

      def update
        routine = Routine.find(params[:routine_id])
        authorize! routine, to: :update?

        re = routine.routine_exercises.find(params[:id])
        re.update!(routine_exercise_params)
        render json: RoutineExerciseSerializer.new(re).as_json, status: :ok
      end

      def destroy
        routine = Routine.find(params[:routine_id])
        authorize! routine, to: :update?

        re = routine.routine_exercises.find(params[:id])
        re.destroy!
        head :no_content
      end

      private

      def routine_exercise_params
        params.permit(:position, :notes)
      end

      def visible_exercise(id)
        ex = Exercise.find_by(id: id)
        unless ex && (ex.is_system? || ex.creator_id == Current.user.id)
          raise ActiveRecord::RecordInvalid.new(RoutineExercise.new.tap { |re|
            re.errors.add(:exercise, "is not visible to user")
          })
        end
        ex
      end
    end
  end
end
