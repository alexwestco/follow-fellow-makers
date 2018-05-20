class AddTweetCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tweet_count, :integer
  end
end
