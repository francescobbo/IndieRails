class DeliverWebmentionsJob < ApplicationJob
  queue_as :default

  def perform(post)
    WebmentionManager.new(post).deliver
  end
end
