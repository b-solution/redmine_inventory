class Warehouse < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  validates_presence_of :name, :location

  has_many :inventories
  has_many :warehouse_users

  safe_attributes 'name', 'location'

  def self.visible
    if User.current.admin?
      all
    else
      whu = WarehouseUser.get_warehouses
      if whu.present?
        where(id: whu.map(&:warehouse_id))
      else
        []
      end
    end
  end

  def editable_by?(user)
    user.admin? or where(user_id: user.id).
        where(can_manage: true).
        where(warehouse_id: self.id).present?
  end

  def to_s
    name
  end


end
