class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.present?  # additional permissions for logged in users
      can :read, :all # permissions for every user, even if not logged in
    end
    if user.has_role?(:admin)  # additional permissions for administrators
      can :manage, :all
    elsif user.has_role?(:editor)  # additional permissions for administrators
      can :create, Profile # can create
      can :create, Evaluation
      can :create, Control
      can :create, Result
      can :update, Profile, created_by_id: user.id # can update if own
      can :update, Evaluation, created_by_id: user.id
      can :update, Control, created_by_id: user.id
      can :update, Result, created_by_id: user.id
      can :delete, Profile, created_by_id: user.id # can delete if own
      can :delete, Evaluation, created_by_id: user.id
      can :delete, Control, created_by_id: user.id
      can :delete, Result, created_by_id: user.id
    end
  end
end
