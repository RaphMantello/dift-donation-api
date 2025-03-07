require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a valid email and password" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end
end
