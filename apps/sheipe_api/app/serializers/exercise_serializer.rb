class ExerciseSerializer
  include Alba::Resource

  attributes :id, :name, :description, :muscle_group, :category, :is_system, :creator_id, :created_at, :updated_at
end
