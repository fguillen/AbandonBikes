erb_config = ERB.new File.read("#{Rails.root}/config/app_config.yml.erb")
APP_CONFIG = YAML.load(erb_config.result(binding))[Rails.env]