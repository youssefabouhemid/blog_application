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
    token = request.headers["Authorization"].split(" ").last
    user_id = JwtService.get_sub(token)
    render({
             json: user_id,
             status: :ok
           })
  end

  def update
  end

  def delete
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

end
