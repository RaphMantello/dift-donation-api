class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[sign_up login]

  def sign_up
    user = User.new(user_params)
    if user.save
      token = encode_token({ user_id: user.id })
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # Logout logic with blacklisting of tokens

  private

  def user_params
    params.permit(:email, :password)
  end
end
