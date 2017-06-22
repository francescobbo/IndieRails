class UseStiForPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :type, :string, null: false, default: 'Article'

    Post.where(kind: 'note').update(type: 'Note')
    Post.where(kind: 'like').update(type: 'Like')

    remove_column :posts, :kind
  end
end
