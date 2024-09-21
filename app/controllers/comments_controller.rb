class CommentsController < ApplicationController
def list
    post_id = params[:post_id]
    if Post.exists?(post_id)
      comments = Comment.where(post_id: post_id)
      render({
               json: CommentSerializer.new(comments).serializable_hash[:data].map { |comment| comment[:attributes] },
               status: :ok
             })
    else
      render({
               json: { error: "Couldn't find Post with 'id'=#{post_id}" },
               status: :not_found
             })
    end
  end

  def create
    user_id = get_user_id
    return unless user_id

    begin
      result = CommentsService.save(create_comment_params, params[:post_id], user_id)
      render({ json: result, status: :created })
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
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
      CommentsService.update(create_comment_params, params[:comment_id], user_id)
      render({ status: :no_content })
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException => e
      render({ json: { error: e.message }, status: :forbidden })
    rescue Exception => e
      render({ json: { error: e.message }, status: :internal_server_error })
    end
  end

  def destroy
    user_id = get_user_id
    return unless user_id

    begin
      CommentsService.delete(params[:comment_id], user_id)
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException => e
      render({ json: { error: e.message }, status: :forbidden })
    rescue Exception => e
      render({ json: { error: e.message }, status: :internal_server_error })
    end
  end


  private

  def create_comment_params
    params.require(:comment).permit(:body).tap do |parameters|
      raise ArgumentError.new("Body required") unless parameters[:body].present?
    end
  end
end
