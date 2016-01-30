require_dependency 'users_helper'

module  RedmineCrm
  module UsersHelperPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :user_settings_tabs, :new_column
      end
    end

  end
  module ClassMethods

  end

  module InstanceMethods
    def user_settings_tabs_with_new_column
      tabs = user_settings_tabs_without_new_column
      tabs<< {:name => 'warehouse', :partial => 'warehouses/membership', :label => :label_warehouse_plural}

      tabs
    end
  end

end