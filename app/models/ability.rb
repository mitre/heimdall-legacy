class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      # permissions for every user, even if not logged in
      can :read, :all
      if user.has_role?(:editor)
        # additional permissions for logged in users
        can :manage, [
          Evaluation,
          Profile,
          Result,
          User,
          Control,
          Depend,
          Repo,
          RepoCred,
          Group,
          Role,
          Support,
          Tag,
        ], created_by_id: user.id
      end
      if user.has_role?(:admin)
        can :manage, :all
      end
    end
  end
end
