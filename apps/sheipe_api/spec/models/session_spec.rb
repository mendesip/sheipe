require 'rails_helper'

RSpec.describe Session, type: :model do
  subject(:session) { create(:session) }

  it 'generates access_token on create' do
    expect(session.access_token).to be_present
  end

  it 'sets access_token_expires_at ~24h from now' do
    expect(session.access_token_expires_at).to be_within(5.seconds).of(24.hours.from_now)
  end

  it 'generates refresh_token on create' do
    expect(session.refresh_token).to be_present
  end

  it 'sets refresh_token_expires_at ~30d from now' do
    expect(session.refresh_token_expires_at).to be_within(5.seconds).of(30.days.from_now)
  end

  it 'enforces unique access_token' do
    duplicate = build(:session, access_token: session.access_token)
    expect(duplicate).not_to be_valid
  end
end
