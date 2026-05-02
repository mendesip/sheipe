class Exercise < ApplicationRecord
  MUSCLE_GROUPS = %w[chest back shoulders biceps triceps legs glutes core full_body].freeze
  CATEGORIES = %w[strength cardio mobility].freeze

  belongs_to :creator, class_name: "User", optional: true

  enum :muscle_group, MUSCLE_GROUPS.index_by(&:itself)
  enum :category, CATEGORIES.index_by(&:itself)

  validates :name, presence: true
  validates :muscle_group, presence: true
  validates :category, presence: true
end
