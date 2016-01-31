class Inventory < ActiveRecord::Base
  unloadable

  include Redmine::SafeAttributes

  belongs_to :warehouse
  acts_as_customizable
  validates_presence_of :name, :warehouse_id
  validates_presence_of :status, :reason, :if => :check_moves
  safe_attributes 'type' , 'name' , 'description' ,
                  'part_number', 'date_in' , 'date_out' ,
                  'quantity', 'minimum_quantity', 'warehouse_id',
                  'custom_field_values',
                  'custom_fields', 'status', 'reason'

  def check_moves
    return false if self.new_record?
    Inventory.find(self.id).warehouse_id != self.warehouse_id
  end

  def visible_custom_field_values(user=nil)
    user_real = user || User.current
    custom_field_values
  end

  def editable_custom_field_values(user=nil)
    visible_custom_field_values(user)
  end

  # Returns true if the attribute is required for user
  def required_attribute?(name, user=nil)
    required_attribute_names(user).include?(name.to_s)
  end

  def self.visible
    if User.current.admin?
      where(nil)
    else
      wu = WarehouseUser.where(user_id: User.current.id).pluck(:warehouse_id)
      Inventory.where(warehouse_id: wu)
    end
  end

  def editable_by?
    return true if User.current.admin?
    @can_edit ||= {}
    @can_edit[self.warehouse_id.to_s.to_sym] ||= WarehouseUser.where(user_id: User.current.id).where(warehouse_id: self.warehouse_id).where(can_manage:true).present?
  end
end
