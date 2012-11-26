require "rspec/core/rake_task"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/test_*.rb'
  spec.rspec_opts = ['--backtrace']
end
task :default => :spec