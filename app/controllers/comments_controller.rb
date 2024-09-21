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
    return render({ json: { error: "invalid id" }, status: :bad_request }) unless user_id

    begin
      result = CommentsService.save(create_comment_params, params[:post_id])
      if result.is_a?(Hash) && result[:error] # todo: change this is ugly and not safe
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
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue ArgumentError => e
      render({
               json: { error: e.message },
               status: :unprocessable_content
             })
    end
  end

  def update
    begin
      user_id = get_user_id
    rescue JWT::DecodeError
      render({ json: { error: "invalid jwt" }, status: :unauthorized }) and return
    end

    begin
      CommentsService.update(create_comment_params, params[:comment_id], user_id)
      render({ status: :no_content })
    rescue ActiveRecord::RecordNotFound => e
      render({ json: { error: e.message }, status: :not_found })
    rescue NotAuthorOwnerException
      render({ status: :forbidden })
    rescue Exception
      render({ status: :internal_server_error })
    end
  end

  def destroy
  end


  private

  def create_comment_params
    params.require(:comment).permit(:body).tap do |parameters|
      raise ArgumentError.new("Body required") unless parameters[:body].present?
    end
  end
end
