class PublicUserSerializer
  include Alba::Resource

  attributes :id, :name, :role, :created_at
end
