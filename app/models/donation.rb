class Donation < ApplicationRecord
  belongs_to :user
  belongs_to :project

  monetize :amount_cents
end
