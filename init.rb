Redmine::Plugin.register :redmine_inventory do
  name 'Redmine Crm plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  settings :default => [
          'name',
          'date_in' ,
          'date_out' ,
          'quantity' ,
          'warehouse']

  menu :top_menu, :warehouses,
       {:controller => 'warehouses', :action => 'index', :project_id => nil},
       :caption => :label_warehouse_plural,
       :if => Proc.new{ User.current.admin? or WarehouseUser.can_access_warehouse_list?}

end


Rails.application.config.to_prepare do
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom, :partial=> 'inventories/new_inventory'

    def controller_issues_new_after_save(context={})
      p = context[:params]
      if p[:inventory]
        @inventory = Inventory.new
        @inventory.safe_attributes = p[:inventory]
        @inventory.save
      end
    end
  end

  Enumeration.send(:include, RedmineInventory::EnumerationPatch)
  CustomFieldsHelper.send(:include, RedmineInventory::CustomFieldsHelperPatch)
  SettingsHelper.send(:include, RedmineInventory::SettingsHelperPatch)
  UsersHelper.send(:include, RedmineInventory::UsersHelperPatch)
end

