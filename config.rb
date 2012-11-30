# default environment to development
ENV['RACK_ENV'] ||= 'development'

# copy the configuration to ENV
if (file = Path.dir/'config.yml').exists?
  require 'yaml'
  config = file.load
  config[ENV['RACK_ENV']].each_pair{|k,v| ENV[k] = v}
  config['*'].each_pair{|k,v| ENV[k] = v}
end
