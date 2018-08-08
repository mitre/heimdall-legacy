# Create public circle if it doesn't exist
# and add all users to it
unless Circle.where(name: 'Public').present?
  @circle = Circle.create(name: 'Public')
  User.each do |user|
    user.add_role(:member, @circle)
  end
end
