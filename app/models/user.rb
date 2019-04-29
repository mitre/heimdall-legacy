require 'securerandom'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::User
  rolify
  after_create :assign_default_role, :add_to_public_circle

  field :first_name, type: String
  field :last_name, type: String
  field :api_key, type: Mongoid::EncryptedString
  mount_uploader :image, ImageUploader

  scope :recent, ->(num) { order(created_at: :desc).limit(num) }

  # new users get assigned the :editor role by default
  def assign_default_role
    add_role(:editor) if roles.blank?
  end

  # all users get added to the public circle
  def add_to_public_circle
    @circle = Circle.where(name: 'Public').try(:first)
    add_role(:member, @circle) if @circle
  end

  # list of a user's role names
  def role_names
    roles.map { |role| role.name.capitalize }
  end

  def my_evaluations
    Evaluation.where(created_by: id)
  end

  def readable_evaluations
    if has_role?(:admin)
      retval = Evaluation.includes(:profiles).all
    else
      retval = Evaluation.includes(:profiles).where(created_by: id)
      my_circles.each do |circle|
        retval += circle.evaluations
      end
    end
    retval.uniq(&:id).sort_by { |t| [t.profiles.map(&:name).join(', '), t.start_time.nil? ? 0 : t.start_time.to_i] }
  end

  def readable_profiles
    if has_role?(:admin)
      retval = Profile.all
    else
      retval = Profile.where(created_by: id)
      readable_evaluations.each do |eval|
        retval += eval.profiles
      end
      my_circles.each do |circle|
        retval += circle.profiles
      end
    end
    retval.uniq(&:id).sort_by(&:name)
  end

  def my_profiles
    Profile.where(created_by: id)
  end

  def my_circles
    Circle.with_role(:owner, self) + Circle.with_role(:member, self)
  end

  def readable_evaluation?(eval_id)
    ids = readable_evaluations.map(&:id)
    ids.include? eval_id
  end

  def readable_profile?(profile_id)
    ids = readable_profiles.map(&:id)
    ids.include? profile_id
  end
end
