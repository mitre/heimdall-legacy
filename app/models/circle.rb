class Circle < ApplicationRecord
  resourcify
  has_and_belongs_to_many :evaluations
  has_and_belongs_to_many :profiles
  belongs_to :created_by, class_name: 'User'
  validates_presence_of :name
  after_create :assign_owner

  def readable_profiles
    retval = profiles
    evaluations.each do |eval|
      retval += eval.profiles
    end
    retval.uniq(&:id).sort_by(&:name)
  end

  def recents
    recents = {}
    recents = fill_recents(recents, evaluations)
    recents = fill_recents(recents, profiles)
    recents = fill_recents(recents, User.with_role(:owner, self))
    recents = fill_recents(recents, User.with_role(:member, self))

    recents = Hash[recents.sort_by { |key, _| key }]
    ret_hsh = {}
    recents.each do |tl, ary|
      ret_hsh[tl] = ary.sort_by(&:created_at)
    end
    ret_hsh
  end

  def fill_recents(recents, recent_objs)
    recent_objs.each do |obj|
      next if obj.created_at.nil?

      key = obj.created_at.beginning_of_day
      recents[key] = [] unless recents.key?(key)
      recents[key] << obj
    end
    recents
  end

  private

  def assign_owner
    self.created_by.add_role(:owner, self)
  end
end
