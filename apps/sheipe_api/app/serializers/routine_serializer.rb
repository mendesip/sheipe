class RoutineSerializer
  include Alba::Resource

  attributes :id, :name, :description, :creator_id, :is_template, :created_at, :updated_at

  many :exercises, resource: RoutineExerciseSerializer, source: ->(_params) { routine_exercises }
end
