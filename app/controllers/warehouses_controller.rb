class WarehousesController < ApplicationController
  unloadable

  before_filter :authorize_view, only: [:show, :index]
  before_filter :authorize_manage, except: [:show, :index]
  before_filter :get_warehouse, only:[:show, :edit, :update, :destroy]

  def index
    @warehouses = Warehouse.visible
  end

  def show
    @inventories = @warehouse.inventories
  end

  def new
    @warehouse = Warehouse.new
  end


  def create
    @warehouse = Warehouse.new
    @warehouse.name = params[:warehouse][:name]
    @warehouse.location = params[:warehouse][:location]

    if @warehouse.save
      redirect_to warehouses_path
    else
      render :new
    end

  end


  def edit
  end


  def update
    @warehouse.name = params[:warehouse][:name]
    @warehouse.location = params[:warehouse][:location]

    if @warehouse.save
      redirect_to warehouses_path
    else
      render :edit
    end
  end


  def destroy
    @warehouse.destroy
    redirect_to warehouses_path
  end


  def manage_roles
    @warehouse = WarehouseUser.where(user_id: params[:warehouse_user][:user_id]).
        where(warehouse_id: params[:warehouse_user][:warehouse_id]).first_or_initialize
    @warehouse.safe_attributes= params[:warehouse_user]
    @warehouse.save
    @user = User.find @warehouse.user_id
    @wu = WarehouseUser.where(user_id:  @user.id)
    redirect_to :back
  end

  def delete_wu
    @warehouse = WarehouseUser.find(params[:warehouse_user_id])
    @warehouse.destroy
    redirect_to :back
  end


  private

  def authorize_manage
    deny_access unless WarehouseUser.can_manage_warehouse_list?
  end

  def authorize_view
    deny_access unless WarehouseUser.can_access_warehouse_list?
  end

  def get_warehouse
    @warehouse = Warehouse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end


end
