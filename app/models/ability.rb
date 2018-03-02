class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, :all  # permissions for every user, even if not logged in
      if user.has_role?(:editor)  # additional permissions for logged in users (they can manage their posts)
        can :manage, [Evaluation, Profile, Result, User, Control, Depend,
          Repo, RepoCred, Group, Role, Support, Tag], created_by_id: user.id
        if user.has_role?(:admin)  # additional permissions for administrators
          can :manage, :all
        end
      end
    end
  end
end
