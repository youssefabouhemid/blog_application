class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :body, :created_at, :user_id

  attribute(:author_id) {|post| post.user_id}
end
