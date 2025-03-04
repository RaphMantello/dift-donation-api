class Donation < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :amount_cents, presence: true
  validates :currency, presence: true
end
