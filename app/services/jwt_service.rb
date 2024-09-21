# frozen_string_literal: true

class JwtService
  def self.get_sub(token)
    decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
    decoded_token[0]["sub"]
  # rescue JWT::DecodeError
  #   nil
  end
end
