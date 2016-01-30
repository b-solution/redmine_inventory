class CreateWarehouseUsers < ActiveRecord::Migration
  def change
    create_table :warehouse_users do |t|

      t.integer :user_id

      t.integer :warehouse_id

      t.boolean :can_view

      t.boolean :can_manage


    end

  end
end
