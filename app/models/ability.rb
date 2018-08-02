class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      # permissions for every user, even if not logged in
      # can :read, :all
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
          Filter,
          FilterGroup,
          Circle,
        ], created_by_id: user.id
        can :manage, Circle, id: Circle.with_role(:owner, user).pluck(:id)
        can :read, Circle, id: Circle.with_role(:member, user).pluck(:id)
        can :write, Circle, id: Circle.with_role(:member, user).pluck(:id)
        can :read, [Filter, FilterGroup, Repo, RepoCred, Role]
        can [:read], Evaluation do |evaluation|
          user.readable_evaluation?(evaluation.id)
        end
        can [:read], Profile do |profile|
          user.readable_profile?(profile.id)
        end
      end
      if user.has_role?(:admin)
        can :manage, :all
      end
    else
      user = User.new
      circle = Circle.where(name: 'Public').try(:first)
      if circle.present?
        can :read, circle
        can [:read], Evaluation do |evaluation|
          circle.evaluations.map(&:id).include?(evaluation.id)
        end
        can [:read], Profile do |profile|
          circle.readable_profiles.map(&:id).include?(profile.id)
        end
      end
    end
  end
end
