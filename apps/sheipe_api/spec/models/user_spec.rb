require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is invalid with blank name' do
    user.name = ''
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with blank email' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it 'is invalid with duplicate email (case-insensitive)' do
    create(:user, email: 'Test@example.com')
    user.email = 'test@example.com'
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'is invalid with malformed email' do
    user.email = 'not-an-email'
    expect(user).not_to be_valid
  end

  it 'rejects admin role on create' do
    user.role = :admin
    expect(user).not_to be_valid
  end

  it 'allows athlete role' do
    user.role = :athlete
    expect(user).to be_valid
  end

  it 'allows trainer role' do
    user.role = :trainer
    expect(user).to be_valid
  end

  it 'authenticates with correct password' do
    user.save!
    expect(user.authenticate(user.password)).to be_truthy
  end
end
