module WarehousesHelper
  def can_manage_warehouses
    @can_manage_warehouses ||= WarehouseUser.can_manage_warehouse_list?
  end

  def can_view_warehouses
    @can_view_warehouses ||= WarehouseUser.can_access_warehouse_list?
  end
end
