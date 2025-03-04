require 'rails_helper'

RSpec.describe Donation, type: :model do
  it "is valid with a valid amount, project, user" do
    donation = build(:donation)
    expect(donation).to be_valid
  end

  it "is invalid without an amount" do
    donation = build(:donation, amount_cents: nil)
    expect(donation).not_to be_valid
  end
end
