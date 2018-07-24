# lib/tasks/migrate/users.rake
namespace :migrate do
  desc 'Migrate users from new db_user type'
  task users: :environment do
    User.each do |user|
      user._type = 'DbUser'
      user.save
    end
  end
end
