class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|

      t.string :type

      t.string :name

      t.string :description

      t.integer :part_number
      t.integer :activity_id

      t.date :date_in

      t.date :date_out

      t.float :quantity

      t.float :minimum_quantity


    end

  end
end
