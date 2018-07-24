require 'securerandom'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::User
  rolify
  after_create :assign_default_role

  field :first_name, type: String
  field :last_name, type: String
  field :profile_pic_name, type: String
  field :api_key, type: Mongoid::EncryptedString

  # new users get assigned the :editor role by default
  scope :recent, ->(num) { order(created_at: :desc).limit(num) }

  def assign_default_role
    add_role(:editor) if roles.blank?
  end

  # list of a user's role names
  def role_names
    roles.map { |role| role.name.capitalize }
  end

  def my_evaluations
    Evaluation.where(created_by: id)
  end

  def readable_evaluations
    retval = Evaluation.where(created_by: id)
    my_circles.each do |circle|
      retval += circle.evaluations
    end
    retval.uniq(&:id).sort_by { |t| [t.profiles.map(&:name).join(', '), t.start_time.nil? ? 0 : t.start_time.to_i] }
  end

  def readable_profiles
    retval = Profile.where(created_by: id)
    my_circles.each do |circle|
      retval += circle.profiles
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
    Rails.logger.debug "readable_evaluation?(#{eval_id})"
    ids = Evaluation.where(created_by: id).map(&:id)
    Rails.logger.debug "ids: #{ids.inspect} - include? #{ids.include? eval_id}"
    return true if ids.include? eval_id
    my_circles.each do |circle|
      ids = circle.evaluations.map(&:id)
      Rails.logger.debug "circle #{circle.name} #{ids.inspect} - include? #{ids.include? eval_id}"
    end
    ids.include? eval_id
  end

  def readable_profile?(profile_id)
    Rails.logger.debug "readable_profile?(#{profile_id})"
    ids = Profile.where(created_by: id).map(&:id)
    Rails.logger.debug "ids: #{ids.inspect} - include? #{ids.include? profile_id}"
    return true if ids.include? profile_id
    my_circles.each do |circle|
      ids = circle.profiles.map(&:id)
      Rails.logger.debug "circle #{circle.name} #{ids.inspect} - include? #{ids.include? profile_id}"
    end
    ids.include? profile_id
  end
end
