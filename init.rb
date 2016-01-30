Redmine::Plugin.register :redmine_crm do
  name 'Redmine Crm plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  settings :default => {
      default:[
          'name',
          'date_in' ,
          'date_out' ,
          'quantity' ,
          'warehouse']
        }

  menu :top_menu, :warehouses,
       {:controller => 'warehouses', :action => 'index', :project_id => nil},
       :caption => :label_warehouse_plural,
       :if => Proc.new{ User.current.admin? or WarehouseUser.can_access_warehouse_list?}

  menu :admin_menu, :warehouses, {:controller => 'warehouses', :action => 'manage_roles', :id => "redmine_warehouses"}, :caption => :label_warehouse_plural

end


Rails.application.config.to_prepare do
  Enumeration.send(:include, RedmineCrm::EnumerationPatch)
  CustomFieldsHelper.send(:include, RedmineCrm::CustomFieldsHelperPatch)
  SettingsHelper.send(:include, RedmineCrm::SettingsHelperPatch)
  UsersHelper.send(:include, RedmineCrm::UsersHelperPatch)
end
