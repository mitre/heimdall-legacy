# frozen_string_literal: true

require 'settingslogic'

# Load settings that are used globally throughout the application.
# We load settings from a file in order to allow the most flexability
# across deployment types. Since SettingsLogic does ERB parsing, we
# are also able to load some basic settings using environment variables.
# For a full list of settings that can be applied using environment
# variables, check heimdall.default.yml.
#
# Note, once you create a heimdall.yml, environment variable parsing
# will no longer work unless you include the `ENV` declarations in
# your copy of heimdall.yml as well.
#
class Settings < Settingslogic
  class << self
    def find_config
      # There are 2 locations that we check for config files,
      # either we check the default location or we check if
      # the user has created a heimdall.yml
      ['heimdall.yml', 'heimdall.default.yml'].each do |config|
        path = get_full_path_for(config)
        return path if path.exist?
      end

      nil # Neither config file exists, this should never happen
    end

    def get_full_path_for(config_file)
      Pathname.new(File.expand_path('..', __dir__)).join("config/#{config_file}")
    end
  end

  source ENV.fetch('HEIMDALL_CONFIG') { find_config }
  namespace ENV.fetch('HEIMDALL_ENV') { Rails.env }
end
