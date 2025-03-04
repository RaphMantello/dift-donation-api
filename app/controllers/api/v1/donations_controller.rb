class Api::V1::DonationsController < ApplicationController
  def create
    # logic to convert all amounts to euros (if possible to pay in other currencies)
    donation = Donation.new(donation_params)
    donation.user = @current_user

    if donation.save
      render json: donation, status: :created
    else
      render json: { errors: donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_total
    amount_cents = @current_user.total_donations

    if params[:currency]
      # logic to validate currencies format 'EUR' (FrontEnd validations possible)
      convertor = ConversionService.new
      conversion = convertor.pair_conversion('EUR', params[:currency], amount_cents)
      converted_amount_cents = conversion['conversion_result']
    end

    render json: {
      amount_cents: converted_amount_cents || amount_cents,
      currency: params[:currency] || 'EUR'
    }
  end

  private

  def donation_params
    params.require(:donation).permit(:amount_cents, :project_id)
  end
end
