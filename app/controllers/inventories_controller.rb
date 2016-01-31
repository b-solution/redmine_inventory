class InventoriesController < ApplicationController
  unloadable

  before_filter :get_warehouse
  before_filter :authorize_manage
  before_filter :get_inventory, only: [:edit, :update, :destroy, :show, :move]

  helper :custom_fields
  include CustomFieldsHelper
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper

  def index
    @query = InventoryQuery.build_from_params(params, :name => '_')

    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.sort_criteria = sort_criteria.to_a

    if @query.valid?
      case params[:format]
        when 'csv', 'pdf'
          @limit = Setting.issues_export_limit.to_i
          if params[:columns] == 'all'
            @query.column_names = @query.available_inline_columns.map(&:name)
          end
        when 'atom'
          @limit = Setting.feeds_limit.to_i
        when 'xml', 'json'
          @offset, @limit = api_offset_and_limit
          @query.column_names = %w(author)
        else
          @limit = per_page_option
      end
      scope = inventory_scope(:order => sort_clause)
      @entry_count = scope.count
      @entry_pages = Paginator.new @entry_count, per_page_option, params['page']
      @inventories = scope.offset(@entry_pages.offset).limit(@entry_pages.per_page).all
      render :layout => !request.xhr?
    else
      respond_to do |format|
        format.html { render(:template => 'issues/index', :layout => !request.xhr?) }
        format.any(:atom, :csv, :pdf) { render(:nothing => true) }
        format.api { render_validation_errors(@query) }
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end


  def new
    if Warehouse.visible.blank?
      flash[:error] = "No Warehouse found"
      redirect_to warehouses_path
    end
    @inventory = Inventory.new
    if @warehouse
      @inventory.warehouse_id =  @warehouse.id
    end
  end

  def create
    @inventory = Inventory.new
    @inventory.safe_attributes = params[:inventory]
    if @inventory.save
      redirect_to warehouse_inventories_path(@inventory.warehouse)
    else
      render :new
    end
  end

  def move
    if request.post?
      @inventory.safe_attributes = params[:inventory]
      if @inventory.save
        redirect_to warehouse_inventories_path(@inventory.warehouse)
      else
        render :move
      end
    end
  end

  def show
  end


  def edit
  end

  def update
    @inventory.safe_attributes = params[:inventory]
    if @inventory.save
      redirect_to warehouse_inventories_path(@inventory.warehouse)
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to inventories_path
  end

  private
  def get_inventory
    @inventory = Inventory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_warehouse
    if params[:warehouse_id]
      @warehouse = Warehouse.find(params[:warehouse_id])
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize_manage
    if params[:warehouse_id]
      deny_access unless @warehouse.editable_by?(User.current)
    end
  end

  def inventory_scope(options={})
    scope = @query.results_scope(options)

    scope
  end


end
