require 'toml-rb'

# reads and parses TOML config files
class Config
  @config = nil
  def self.get
    return @config if @config
    user_config ||= TomlRB.load_file('./config/config.toml', symbolize_keys: true)
    env_config = {}
    env_config = TomlRB.load_file('./config/config.dev.defaults.toml', symbolize_keys: true) if ENV['APP_ENV'] != 'production'
    env_config = TomlRB.load_file('./config/config.prod.defaults.toml', symbolize_keys: true) if ENV['APP_ENV'] == 'production'
    @config = env_config.merge(user_config)
  end
end
