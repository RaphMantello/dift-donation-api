class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_user!

  private

  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
  rescue
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
