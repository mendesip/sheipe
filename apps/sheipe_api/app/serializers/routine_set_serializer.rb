class RoutineSetSerializer
  include Alba::Resource

  attributes :id, :routine_exercise_id, :set_number, :weight, :reps, :rest_seconds, :set_type, :created_at, :updated_at
end
