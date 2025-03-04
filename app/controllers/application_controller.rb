class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_user!

  private

  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)

    if decoded && (@current_user = User.find_by(id: decoded[:user_id]))
      return
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
