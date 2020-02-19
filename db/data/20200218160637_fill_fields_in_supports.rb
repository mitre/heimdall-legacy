class FillFieldsInSupports < ActiveRecord::Migration[5.2]
  def up
    Support.all.each do |support|
      if support.name.present?
        hsh = JSON.parse(support.name.gsub('=>', ':'))
        support.os_family = hsh['os_family'] if hsh.key?('os_family')
        support.os_name = hsh['os_name'] if hsh.key?('os_name')
        support.platform = hsh['platform'] if hsh.key?('platform')
        support.platform_family = hsh['platform_family'] if hsh.key?('platform_family')
        support.platform_name = hsh['platform_name'] if hsh.key?('platform_name')
        support.release = hsh['release'] if hsh.key?('release')
        support.inspec_version = hsh['inspec_version'] if hsh.key?('inspec_version')
        support.save
      end
    end
  end

  def down
    # do nothing
  end
end
