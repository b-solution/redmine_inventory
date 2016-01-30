class Inventory < ActiveRecord::Base
  unloadable

  include Redmine::SafeAttributes

  belongs_to :warehouse
  acts_as_customizable
  validates_presence_of :name, :warehouse_id
  safe_attributes 'type' , 'name' , 'description' ,
                  'part_number', 'date_in' , 'date_out' ,
                  'quantity', 'minimum_quantity', 'warehouse_id',
                  'custom_field_values',
                  'custom_fields'

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
end
