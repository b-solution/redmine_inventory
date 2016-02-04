class InventoryActivity < Enumeration
  has_many :inventories, :foreign_key => 'activity_id'

  OptionName = :enumeration_inventory

  def option_name
    OptionName
  end

  def objects
    Inventory.where(:activity_id => self_and_descendants(1).map(&:id))
  end

  def objects_count
    objects.count
  end

  def transfer_relations(to)
    objects.update_all(:activity_id => to.id)
  end
end