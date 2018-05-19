class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :twitter_username
      t.string :twitter_authentication_token

      t.timestamps
    end
  end
end
