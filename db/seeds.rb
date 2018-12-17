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

Control.each do |control|
  if control.impact.numeric?
    impact = control.impact.to_f
    if impact < 0.1 then control.impact = 'none'
    elsif impact < 0.4 then control.impact = 'low'
    elsif impact < 0.7 then control.impact = 'medium'
    elsif impact < 0.9 then control.impact = 'high'
    elsif impact >= 0.9 then control.impact = 'critical'
    end
    control.save
  end
end
