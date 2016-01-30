class WarehouseUser < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes


  belongs_to :user
  belongs_to :warehouse

  safe_attributes 'user_id', 'warehouse_id', 'can_view', 'can_manage'

  def self.can_access_warehouse_list?(user = User.current)
    user.admin? or where(user_id: user.id).where(can_view: true).first.present?
  end

  def self.can_manage_warehouse_list?(user = User.current)
    user.admin? or where(user_id: user.id).where(can_manage: true).first.present?
  end


  def self.get_warehouses
    where(user_id: User.current.id)
  end

end
