class ApplicationController < ActionController::API
  before_action(:authenticate_user!)

  # def index
  #   render({
  #            json: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
  #            status: :ok
  #          })
  # end


  protected
  def get_bearer_token
    request.headers["Authorization"].split(" ").last
  end

  # Retrieves the user ID from the JWT token.
  # If the token is invalid, it renders an unauthorized status with an error message.
  #
  # @return [Integer, nil] the user ID if the token is valid, otherwise nil.
  def get_user_id
    user_id = JwtService.get_sub(get_bearer_token)
    unless user_id
      render({
               json: "invalid token",
               status: :unauthorized
             })
    end
    user_id
  end
end
