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
      render({ json: result, status: :created })
    rescue ArgumentError => e
      render({ json: { error: e.message }, status: :unprocessable_content })
    rescue Exception => e
      render({ json: { error: e.message }, status: :internal_server_error })
    end
  end

  def update
    user_id = get_user_id
    return unless user_id

    begin
      PostsService.update(update_post_params, params[:id], user_id)
      render({ status: :no_content })
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException => e
      render({ json: { error: e.message }, status: :forbidden })
    rescue ArgumentError => e
      render({ json: { error: e.message }, status: :unprocessable_content })
    rescue Exception => e
      render({ json: { error: e.message }, status: :internal_server_error })
    end
  end

  def destroy
    user_id = get_user_id
    return unless user_id


    begin
      PostsService.delete_by_id(params[:id], user_id)
      render({ status: :no_content })
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException => e
      render({ json: { error: e.message }, status: :forbidden })
    rescue Exception => e
      render({ json: { error: e.message }, status: :internal_server_error })

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
