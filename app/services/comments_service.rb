# frozen_string_literal: true

class CommentsService
  def self.save(comment_params, post_id, user_id)
    post = Post.find(post_id) # throws exception if not found

    # create new comment
    comment = Comment.new(comment_params)
    comment.post = post
    comment.user_id = user_id
    unless comment.save
      { error: comment.errors.full_messages } # todo: change to exception for all
    end
    CommentSerializer.new(comment).serializable_hash[:data][:attributes]
  end


  def self.update(comment_params, comment_id, user_id)
    comment = Comment.find(comment_id)
    if comment.user_id != user_id.to_i
      raise NotAuthorOwnerException.new
    end

    comment.update!(comment_params)
  end
end
