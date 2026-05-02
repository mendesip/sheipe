class RoutineExercise < ApplicationRecord
  belongs_to :routine
  belongs_to :exercise
  has_many :routine_sets, -> { order(:set_number) }, dependent: :destroy

  validates :position, presence: true
end
