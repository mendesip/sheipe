class WorkoutSerializer
  include Alba::Resource

  attributes :id, :user_id, :routine_id, :gym_id, :started_at, :finished_at, :notes, :trainer_notes, :created_at, :updated_at

  many :exercises, resource: WorkoutExerciseSerializer, source: ->(_params) { workout_exercises }
end
