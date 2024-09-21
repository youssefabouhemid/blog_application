class CommentSerializer
  include JSONAPI::Serializer
  attributes :id, :body, :created_at

  attribute(:author_id) { |comment| comment.user_id }
end
