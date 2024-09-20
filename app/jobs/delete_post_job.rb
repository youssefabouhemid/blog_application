# frozen_string_literal: true

class DeletePostJob
  include Sidekiq::Job
  sidekiq_options(retry: false)

  def perform(args)
    post = Post.find_by(id: args["id"])
    post.destroy if post
  end
end
