module ValidatePermission
  def execute_action(current_user: nil, user:, id: nil, action:, other: nil)
    current_user ||= user
    if current_user.admin?
      action.call
    elsif id.present? && other.present? && user.id == id.to_i
      other.call
    elsif other.present? && !id.present?
      other.call
    else
      json_response(Message.unauthorized, :unauthorized)
    end
  end

  def admin_or_self(current_user:, user:, id:, action:, other:)
    execute_action(current_user: current_user, user: user, id: id, action: action, other: other)
  end

  def admin_or_else(user:, action:, other:)
    execute_action(user: user, action: action, other: other)
  end

  def admin_or_fail(user:, action:)
    execute_action(user: user, action: action)
  end
end
