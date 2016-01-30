class AddWarehouseIdToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :warehouse_id, :integer
  end
end
