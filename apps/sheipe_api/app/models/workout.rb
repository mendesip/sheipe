class Workout < ApplicationRecord
  belongs_to :user
  belongs_to :routine, optional: true
  has_many :workout_exercises, -> { order(:position) }, dependent: :destroy

  scope :finished, -> { where.not(finished_at: nil) }

  before_validation :set_started_at, on: :create

  private

  def set_started_at
    self.started_at ||= Time.current
  end
end
