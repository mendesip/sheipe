class RoutineExerciseSerializer
  include Alba::Resource

  attributes :id, :routine_id, :exercise_id, :position, :notes, :created_at, :updated_at

  many :sets, resource: RoutineSetSerializer, source: ->(_params) { routine_sets }
end
