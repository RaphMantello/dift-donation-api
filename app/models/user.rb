class User < ApplicationRecord
  has_secure_password
  has_many :donations

  validates :email, presence: true, uniqueness: true

  def total_donations
    return 0 unless donations

    donations.sum(&:amount_cents)
  end
end
