# frozen_string_literal: true

class CommentsService
  def self.save(comment_params, post_id)
    post = Post.find(post_id)

    comment = Comment.new(comment_params)
    comment.post = post
    comment.user_id = post.user_id
    unless comment.save
      { error: comment.errors.full_messages } # todo: change to exception for all
    end
    CommentSerializer.new(comment).serializable_hash[:data][:attributes]
  end
end
