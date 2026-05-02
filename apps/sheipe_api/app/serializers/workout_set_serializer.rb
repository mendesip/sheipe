class WorkoutSetSerializer
  include Alba::Resource

  attributes :id, :workout_exercise_id, :set_number, :weight, :reps, :rpe, :completed, :notes, :created_at, :updated_at
end
