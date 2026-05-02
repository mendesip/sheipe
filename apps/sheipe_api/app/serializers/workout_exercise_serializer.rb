class WorkoutExerciseSerializer
  include Alba::Resource

  attributes :id, :workout_id, :exercise_id, :routine_exercise_id, :position, :notes, :created_at, :updated_at

  many :sets, resource: WorkoutSetSerializer, source: ->(_params) { workout_sets }
end
