require './app'

def database_url
  ENV['DATABASE_URL']
end

def seed_url
  Path.dir/'database/seed'/ENV['RACK_ENV']
end

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new do |spec|
    spec.pattern = 'spec/test_*.rb'
    spec.rspec_opts = ['--backtrace']
  end
  task :default => :spec
rescue LoadError
end

desc "Ping the database"
task "db:ping" do
  Alf.connect(database_url){|c| puts "Ping #{database_url} ok!" }
end

desc "Migrate the database"
task "db:migrate" => "db:ping" do
  system "sequel -E -m database #{database_url}"
end

task "db:show" => "db:ping"
task "db:show", :which do |t, args|
  Alf.connect(database_url, default_viewpoint: Model) do |db|
    puts db.relvar(args[:which]).to_text
  end
end

task "db:seed" => "db:ping" do
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
