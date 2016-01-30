class InventoryQuery < Query

  self.queried_class = Inventory

  self.available_columns = [
      QueryColumn.new(:warehouse, :sortable => "#{Warehouse.table_name}.name", :groupable => true),
      QueryColumn.new(:location, :sortable => "#{Warehouse.table_name}.location"),
      QueryColumn.new(:type, :sortable => "#{Inventory.table_name}.type"),
      QueryColumn.new(:name, :sortable => "#{Inventory.table_name}.name"),
      QueryColumn.new(:part_number, :sortable => "#{Inventory.table_name}.part_number"),
      QueryColumn.new(:date_in, :sortable => "#{Inventory.table_name}.date_in"),
      QueryColumn.new(:date_out, :sortable => "#{Inventory.table_name}.date_out"),
      QueryColumn.new(:quantity, :sortable => "#{Inventory.table_name}.quantity"),
      QueryColumn.new(:minimum_quantity, :sortable => "#{Inventory.table_name}.minimum_quantity"),
  ]

  def initialize(attributes=nil, *args)
    super attributes
    self.filters ||= {}
    add_filter('name', '*') unless filters.present?
  end

  def initialize_available_filters
    add_available_filter "name", :type => :string, :order => 0
    add_available_filter "type", :type => :string, :order => 1
    add_available_filter "part_number", :type => :string, :order => 2
    add_available_filter "date_in", :type => :string, :order => 3
    add_available_filter "date_out", :type => :string, :order => 4
    add_available_filter "quantity", :type => :text, :order => 5
    add_available_filter "minimum_quantity", :type => :text, :order => 6
    add_available_filter "warehouse_id", :type => :text, :order => 7, :name => l(:label_warehouse_plural)

    add_custom_fields_filters(InventoryCustomField.where(:is_filter => true))
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
    @available_columns
  end

  def default_columns_names
    @default_columns_names ||= [:name, :date_in, :date_out, :quantity, :warehouse]
  end

  def results_scope(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)

    Inventory.
        where(statement).
        order(order_option).
        joins(joins_for_order_statement(order_option.join(',')))
  end

  # Accepts :from/:to params as shortcut filters
  def build_from_params(params)
    super
    if params[:from].present? && params[:to].present?
      add_filter('date_in', '><', [params[:from], params[:to]])
    elsif params[:from].present?
      add_filter('date_in', '>=', [params[:from]])
    elsif params[:to].present?
      add_filter('date_in', '<=', [params[:to]])
    end
    self
  end
end
