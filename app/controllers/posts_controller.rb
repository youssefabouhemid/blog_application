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


    begin
      result = PostsService.save(create_post_params, user_id)
      if result.is_a?(Hash) && result[:error]
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
    rescue ArgumentError => e
      render({
               json: { error: e.message },
               status: :unprocessable_content
             })
    end
  end

  def update
    user_id = get_user_id
    return unless user_id


    begin
      result = PostsService.update(update_post_params, params[:id], user_id)
      if result == true
        render({ status: :no_content })
      else
        render({
                 json: result,
                 status: :unprocessable_content
               })
      end
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException
      render({ status: :forbidden })
    rescue ArgumentError => e
      render({
               json: { error: e.message },
               status: :unprocessable_content
             })
    end
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
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException
      render({ status: :forbidden })
    end
  end

  private


  def create_post_params
    params.require(:post).permit(:title, :body, tags: []).tap do |parameters|
      raise ArgumentError.new("Title required") unless parameters[:title].present?
      raise ArgumentError.new("Body required") unless parameters[:body].present?
      raise ArgumentError.new("Tags required") unless parameters[:tags].present?
    end
  end

  def update_post_params
    params.require(:post).permit(:title, :body, tags: [])
  end
end
