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

  private

  def donation_params
    params.require(:donation).permit(:amount_cents, :project_id)
  end
end
