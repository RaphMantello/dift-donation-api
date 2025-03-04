class User < ApplicationRecord
  has_secure_password
  has_many :donations

  validates :email, presence: true, uniqueness: true

  def total_donations(target_currency)
    return 0 unless donations

    donations.sum do |donation|
      convertor = ConversionService.new
      # could skip API call if donation.currency == target currency
      conversion = convertor.pair_conversion(donation.currency, target_currency, donation.amount_cents)
      conversion['conversion_result']
    end
  end
end
