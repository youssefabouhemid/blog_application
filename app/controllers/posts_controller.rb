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
    user_id = JwtService.get_sub(get_bearer_token)
    unless user_id
      render({
               json: "invalid token",
               status: :unauthorized
             })
    end

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
  end

  def delete
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, tags: [])
  end

end
