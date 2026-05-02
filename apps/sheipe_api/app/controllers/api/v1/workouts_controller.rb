module Api
  module V1
    class WorkoutsController < BaseController
      def index
        scope = authorized_scope(Workout.all)
        scope = scope.where(routine_id: params[:routine_id]) if params[:routine_id].present?
        if params[:start_date].present?
          scope = scope.where("started_at >= ?", Date.parse(params[:start_date]).beginning_of_day)
        end
        if params[:end_date].present?
          scope = scope.where("started_at <= ?", Date.parse(params[:end_date]).end_of_day)
        end
        scope = scope.order(started_at: :desc)
        records, meta = paginate(scope)
        render json: {
          data: WorkoutSerializer.new(records).serializable_hash,
          meta: meta
        }, status: :ok
      end

      def show
        workout = Workout.find(params[:id])
        authorize! workout
        render json: WorkoutSerializer.new(workout).as_json, status: :ok
      end

      def create
        workout = Current.user.workouts.new(workout_params)
        authorize! workout
        if (routine_id = params[:routine_id]).present?
          start_from_routine!(workout, routine_id)
        else
          workout.save!
        end
        render json: WorkoutSerializer.new(workout).as_json, status: :created
      end

      def update
        workout = Workout.find(params[:id])
        authorize! workout
        workout.update!(workout_params)
        render json: WorkoutSerializer.new(workout).as_json, status: :ok
      end

      def destroy
        workout = Workout.find(params[:id])
        authorize! workout
        workout.destroy!
        head :no_content
      end

      def finish
        workout = Workout.find(params[:id])
        authorize! workout, to: :finish?
        workout.update!(finished_at: Time.current) if workout.finished_at.nil?
        render json: WorkoutSerializer.new(workout).as_json, status: :ok
      end

      private

      def workout_params
        params.permit(:notes, :gym_id)
      end

      def start_from_routine!(workout, routine_id)
        routine = Current.user.routines.find_by(id: routine_id)
        unless routine
          workout.errors.add(:routine_id, "is not visible to user")
          raise ActiveRecord::RecordInvalid.new(workout)
        end

        Workout.transaction do
          workout.routine_id = routine.id
          workout.save!
          routine.routine_exercises.each do |re|
            we = workout.workout_exercises.create!(
              exercise: re.exercise,
              routine_exercise: re,
              position: re.position,
              notes: re.notes
            )
            re.routine_sets.each do |rs|
              we.workout_sets.create!(
                set_number: rs.set_number,
                weight: rs.weight,
                reps: rs.reps,
                completed: false
              )
            end
          end
        end
      end
    end
  end
end
