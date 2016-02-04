class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :inventories, :type, :integer
  end
end
