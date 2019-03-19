class V1::MovementsController < ApplicationController
  before_action :set_user
  before_action :set_account
  before_action :set_account_movement, only: [:show, :update, :destroy]

  # GET /accounts/:account_id/movements
  def index
    json_response(@account.movements)
  end

  # POST /accounts/:account_id/movements
  def create
    admin_or_fail(user: current_user, action: -> {
      @account.movements.create!(movement_params)
      json_response(@account, :created)
    })
  end

  # GET /accounts/:account_id/movements/:id
  def show
    json_response(@movement)
  end

  # PUT /accounts/:account_id/movements/:id
  def update
    admin_or_fail(user: current_user, action: -> {
      @movement.update(movement_params)
      head :no_content
    })
  end

  # DELETE /accounts/:account_id/movements/:id
  def destroy
    admin_or_fail(user: current_user, action: -> {
      @movement.destroy
      head :no_content
    })
  end

  private

  def movement_params
    params.permit(:amount, :reference)
  end

  def set_user
    @user = current_user.admin? && params.has_key?(:user_id) ? User.find(params[:user_id]) : current_user
  end

  def set_account
    @account = @user.accounts.find_by!(id: params[:account_id]) if @user
  end

  def set_account_movement
    params[:id] ||= params[:movement_id]
    @movement = @account.movements.find_by!(id: params[:id]) if @account
  end
end
