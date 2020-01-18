# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(current_user)
    can :show, User
    if current_user.superadmin?
      can :update, User
    elsif current_user.user?
      can :update, User do |user|
        user == current_user
      end
    end
  end
end
