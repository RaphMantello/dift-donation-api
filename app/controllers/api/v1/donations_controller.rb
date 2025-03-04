class Api::V1::DonationsController < ApplicationController
  def create
    donation = Donation.new(donation_params)
    donation.user = @current_user

    if donation.save
      render json: donation, status: :created
    else
      render json: { errors: donation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_total
    render json: {
      amount_cents: @current_user.total_donations,
      currency: 'EUR'
    }
  end

  private

  def donation_params
    params.require(:donation).permit(:amount_cents, :project_id)
  end
end
