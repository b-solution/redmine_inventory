# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2011-2015 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

module RedmineCrm
    module SettingsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :administration_settings_tabs, :inventories
        end
      end
    end
    module InstanceMethods
      # include ContactsHelper

      def administration_settings_tabs_with_inventories
        tabs = administration_settings_tabs_without_inventories

        tabs.push({ :name => 'inventory',
                    :partial => 'settings/inventory/settings',
                    :label => :label_inventory_plural })

      end

    end
end
