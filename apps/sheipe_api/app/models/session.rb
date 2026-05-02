class Session < ApplicationRecord
  belongs_to :user

  validates :access_token, uniqueness: true

  before_create :generate_tokens

  def rotate_access_token!
    update!(
      access_token: SecureRandom.uuid,
      access_token_expires_at: 24.hours.from_now
    )
  end

  private

  def generate_tokens
    self.access_token = SecureRandom.uuid
    self.access_token_expires_at = 24.hours.from_now
    self.refresh_token = SecureRandom.uuid
    self.refresh_token_expires_at = 30.days.from_now
  end
end
