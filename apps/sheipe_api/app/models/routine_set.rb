class RoutineSet < ApplicationRecord
  SET_TYPES = %w[warmup working drop_set failure].freeze

  belongs_to :routine_exercise

  enum :set_type, SET_TYPES.index_by(&:itself)

  validates :set_number, presence: true
  validates :set_type,   presence: true
end
