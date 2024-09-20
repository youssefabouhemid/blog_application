require "./app/exceptions/not_author_owner_exception"
class PostsController < ApplicationController
  # before_action(:authenticate_user!)
  def list
    posts = Post.all
    render({
             json: PostSerializer.new(posts).serializable_hash[:data].map { |data| data[:attributes] },
             status: :ok
           })
  end

  def create
    user_id = get_user_id
    return unless user_id
    
    result = PostsService.save(post_params, user_id)
    if result.is_a?(Hash) && result[:errors]
      render({
               json: result,
               status: :unprocessable_content
             })
    else
      render({
               json: result,
               status: :created
             })
    end
  end

  def update
    user_id = get_user_id
    return unless user_id
  end

  def destroy
    user_id = get_user_id
    return unless user_id

    begin
      result = PostsService.delete_by_id(params[:id], user_id)
      if result == true
        render({ status: :no_content })
      else
        render({
                 json: result,
                 status: :unprocessable_content
               })
      end
    rescue ActiveRecord::RecordNotFound
      render({ status: :not_found })
    rescue NotAuthorOwnerException
      render({ status: :forbidden })
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, tags: [])
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
