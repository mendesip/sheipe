module Api
  module V1
    class RoutineSetsController < BaseController
      def create
        re = parent_routine_exercise
        set = re.routine_sets.new(routine_set_params)
        set.save!
        render json: RoutineSetSerializer.new(set).as_json, status: :created
      end

      def update
        re = parent_routine_exercise
        set = re.routine_sets.find(params[:id])
        set.update!(routine_set_params)
        render json: RoutineSetSerializer.new(set).as_json, status: :ok
      end

      def destroy
        re = parent_routine_exercise
        set = re.routine_sets.find(params[:id])
        set.destroy!
        head :no_content
      end

      private

      def parent_routine_exercise
        routine = Routine.find(params[:routine_id])
        authorize! routine, to: :update?
        routine.routine_exercises.find(params[:routine_exercise_id])
      end

      def routine_set_params
        params.permit(:set_number, :weight, :reps, :rest_seconds, :set_type)
      end
    end
  end
end
