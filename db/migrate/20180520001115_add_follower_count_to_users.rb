class AddFollowerCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :follower_count, :integer
  end
end
