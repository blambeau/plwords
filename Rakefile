require './configuration'
include Configuration

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new do |spec|
    spec.pattern = 'spec/test_*.rb'
    spec.rspec_opts = ['--backtrace']
  end
  task :default => :spec
rescue LoadError
end

task "db:show" do
  puts "Using: #{database_url}"
end

task "db:migrate" => "db:show" do
  system "sequel -E -m database #{database_url}"
end

task "db:seed" => "db:show" do
  Alf.connect(seed_url) do |seed|
    Alf.connect(database_url) do |db|
      seed_url.glob('*.rash').each do |file|
        relvarname = file.basename.rm_ext.to_s.to_sym
        puts "Seeding #{relvarname}"
        db.relvar(relvarname).affect(seed.query(relvarname))
      end
    end
  end
end

task "db:print" => "db:show"
task "db:print", :which do |t, args|
  Alf.connect(database_url, default_viewpoint: Model) do |db|
    puts db.relvar(args[:which].to_sym)
           .to_text(order: [[:submission_count, :asc], [:frequency, :asc]])
  end
end
