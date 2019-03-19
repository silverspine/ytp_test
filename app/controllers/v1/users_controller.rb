class V1::UsersController < ApplicationController
  before_action :set_user

  # GET /users/
  def index
    admin_or_else(user: @user, action: -> {
      users = User.all()
      json_response(users)
    }, other: -> {
      show
    })
  end

  # POST /users/
  def create
    admin_or_fail(user: @user, action: -> {
      newUser = User.create!(admin_params)
      json_response(newUser, :created)
    })
  end

  # GET /users/:id
  def show
    json_response(@user)
  end

  # PUT /users/:id
  def update
    admin_or_self(current_user: current_user, user: @user, id: params[:id],
      action: -> {
        @user.update(admin_params)
        head :no_content
      }, other: -> {
        @user.update(user_params)
        head :no_content
      })
  end

  # DELETE
  def destroy
    admin_or_fail(user: current_user, action: -> {
      @user.destroy
      head :no_content
    })
  end

  private

  def admin_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :admin
    )
  end

  def user_params
    params.permit(
      :name,
      :password,
      :password_confirmation
    )
  end

  def set_user
    @user = current_user.admin? && params.has_key?(:id) ? User.find(params[:id]) : current_user
  end
end
