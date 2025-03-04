module JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base || ENV['SECRET_KEY_BASE']

  def encode_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    body, = JWT.decode(token, SECRET_KEY)
    HashWithIndifferentAccess.new(body)
  rescue
    nil
  end
end
