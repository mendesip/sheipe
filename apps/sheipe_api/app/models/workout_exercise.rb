class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise
  belongs_to :routine_exercise, optional: true
  has_many :workout_sets, -> { order(:set_number) }, dependent: :destroy

  validates :position, presence: true
end
