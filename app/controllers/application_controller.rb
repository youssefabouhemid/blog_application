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
end
