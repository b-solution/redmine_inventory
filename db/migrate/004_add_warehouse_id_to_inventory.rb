class AddWarehouseIdToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :warehouse_id, :integer
    add_column :inventories, :status, :string
    add_column :inventories, :reason, :string
  end
end
