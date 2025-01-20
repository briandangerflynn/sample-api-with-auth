class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.credentials.jwt_secret_key || "fun_times_test_key"

  # Method to encode JWT token
  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  # Method to decode JWT token
  def decoded_token
    header = request.headers["Authorization"]
    return nil if header.nil?

    token = header.split(" ")[1]
    begin
      JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
    rescue JWT::DecodeError => e
      nil
    end
  end

  # Method to return the current user from the decoded token
  def current_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def authorized
    render json: { error: "Not Authorized" }, status: :unauthorized unless current_user
  end
end
