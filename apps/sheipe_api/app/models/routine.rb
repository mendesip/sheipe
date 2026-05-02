class Routine < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :routine_exercises, -> { order(:position) }, dependent: :destroy

  validates :name, presence: true
end
