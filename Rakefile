begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new do |spec|
    spec.pattern = 'spec/test_*.rb'
    spec.rspec_opts = ['--backtrace']
  end
  task :default => :spec
rescue LoadError
end

task "db:migrate" do
  puts "Using #{ENV['DATABASE_URL']}"
  system "sequel -E -m database #{ENV['DATABASE_URL']}"
end
