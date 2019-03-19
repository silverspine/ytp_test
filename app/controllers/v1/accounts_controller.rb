class V1::AccountsController < ApplicationController
  before_action :set_user, except: :transfer
  before_action :set_holder, only: :transfer
  before_action :set_account, only: [:show, :update, :destroy, :transfer]
  before_action :set_destination_acc, only: :transfer
  before_action :set_ammount, only: :transfer
  before_action :generate_ref, only: :transfer

  # GET /accounts
  def index
    json_response(@user.accounts)
  end

  # POST /accounts
  def create
    admin_or_fail(user: current_user, action: -> {
      @account = @user.accounts.create!(account_params)
      json_response(@account, :created)
    })
  end

  # GET /accounts/:id
  def show
    json_response(@account)
  end

  # PUT /accounts/:id
  def update
    admin_or_fail(user: current_user, action: -> {
      @account.update!(account_params)
      head :no_content
    })
  end

  # DELETE /accounts/:id
  def destroy
    admin_or_fail(user: current_user, action: -> {
      @account.destroy
      head :no_content
    })
  end

  def transfer
    if @amount.blank? || @amount <= 0
      json_response(Message.incorrect_amount, :unprocessable_entity)
    elsif @account.balance < @amount
      json_response(Message.insuficient_funds, :unprocessable_entity)
    else  
      ActiveRecord::Base.transaction do
        @account.movements.create!(amount: -1*@amount, reference: @reference)
        @destination.movements.create!(amount: @amount, reference: @reference)
      end
      json_response(@account, :created)
    end
  end

  private

  def account_params
    params.permit(
      :CLABE,
      :user_id
    )
  end

  def set_user
    @user = current_user.admin? && params.has_key?(:user_id) ? User.find(params[:user_id]) : current_user
  end

  def set_holder
    @user = current_user
  end

  def set_account
    params[:id] ||= params[:account_id]
    @account = @user.accounts.find_by!(id: params[:id]) if @user
  end

  def set_destination_acc
    @destination = Account.find_by!(CLABE: params[:destination])
  end

  def set_ammount
    @amount = params[:amount].to_f
  end

  def generate_ref
    @reference = SecureRandom.uuid
  end
end
