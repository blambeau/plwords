require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/test_*.rb'
  spec.rspec_opts = ['--backtrace']
end

task "db:migrate" do
  system "sequel -E -m database #{ENV['DATABASE_URL']}"
end

task :default => :spec
