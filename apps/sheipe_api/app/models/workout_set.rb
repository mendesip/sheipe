class WorkoutSet < ApplicationRecord
  belongs_to :workout_exercise

  validates :set_number, presence: true
  validates :rpe, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
end
