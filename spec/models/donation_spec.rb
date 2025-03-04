require 'rails_helper'

RSpec.describe Donation, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it "is valid with valid attributes" do
    donation = build(:donation)
    expect(donation).to be_valid
  end

  it "is invalid without an amount" do
    donation = build(:donation, amount_cents: nil)
    expect(donation).not_to be_valid
  end
end
