class AddAddedByToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :added_by, :string
  end
end
