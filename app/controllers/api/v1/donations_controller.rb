class Api::V1::DonationsController < ApplicationController
  def create
    # logic to convert all amounts to euros (if possible to pay in other currencies)
    donation = Donation.new(donation_params)
    # donation.amount = donation.convert_to_euros
    donation.user = @current_user

    if donation.save
      render json: donation, status: :created
    else
      render json: { errors: donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_total
    amount_cents = @current_user.total_donations(params[:currency])

    render json: {
      amount_cents: amount_cents,
      currency: params[:currency]
    }
  end

  private

  def donation_params
    params.require(:donation).permit(:amount_cents, :currency, :project_id)
  end
end
