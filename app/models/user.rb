require 'securerandom'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  rolify
  include Mongoid::Userstamps::User
  after_create :assign_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :first_name,  type: String
  field :last_name,  type: String
  field :profile_pic_name,  type: String
  field :api_key, type: String

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
    retval
  end

  def readable_profiles
    retval = Profile.where(created_by: id)
    my_circles.each do |circle|
      retval += circle.profiles
    end
    retval
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
