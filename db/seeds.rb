# Create public circle if it doesn't exist
# and add all users to it
unless Circle.where(name: 'Public').present?
  @circle = Circle.create(name: 'Public')
  User.each do |user|
    user.add_role(:member, @circle)
  end
end

Profile.each do |profile|
  values = []
  profile.supports.each do |support|
    if support.has_attribute?(:os_family)
      values << support.os_family
    end
    support.destroy
  end
  values.each do |value|
    profile.supports.create(name: 'os-family', value: value)
  end
end
