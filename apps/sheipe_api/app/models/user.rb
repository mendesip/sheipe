class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, { athlete: 0, trainer: 1, admin: 2 }, default: :athlete

  validates :name, presence: true
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :role_not_admin, on: :create

  before_save :downcase_email

  private

  def role_not_admin
    errors.add(:role, "admin role is not allowed") if role == "admin"
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
