class AddReplyToToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :reply_to, :text
  end
end
