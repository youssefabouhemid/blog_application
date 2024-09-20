# frozen_string_literal: true

require "./app/exceptions/not_author_owner_exception"
class PostsService
  def self.save(post_params, user_id)
    # extract tags and query them
    tag_values = post_params.delete(:tags)
    if tag_values.present?
      tags = tag_values.map { |value| Tag.find_by_value(value) }
      if tags.any? { |tag| tag == nil }
        return { errors: "Invalid tag(s)." }
      end
    end


    post = Post.new(post_params)
    post.user_id = user_id
    post.tags = tags
    unless post.save
      return { errors: post.errors.full_messages }
    end
    PostSerializer.new(post).serializable_hash[:data][:attributes]
  end


  def self.delete_by_id(post_id, user_id)
    post = Post.find(post_id) # throws RecordNotFound
    if post.user_id != user_id.to_i
      raise NotAuthorOwnerException.new
    end

    if post.destroy
      true
    else
      { errors: post.errors.full_messages }
    end
  end
end
