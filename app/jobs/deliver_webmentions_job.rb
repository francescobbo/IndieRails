class DeliverWebmentionsJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.deliver_webmentions
  end
end
