# This is a sample Capistrano config file for rubber

# Fix for bad rake 0.9
set :rake, 'bundle exec rake'

set :rails_env, RUBBER_ENV

on :load do
  set :application, rubber_env.app_name
  set :runner,      rubber_env.app_user
  set :deploy_to,   "/mnt/#{application}-#{RUBBER_ENV}"
  set :copy_exclude, [".git/*", ".bundle/*", "log/*"]
end

# Use a simple directory tree copy here to make demo easier.
# You probably want to use your own repository for a real app
#set :scm, :none
#set :repository, "."
#set :deploy_via, :copy
#NOTE Using git fails with "Instance not found for host production" since the instance-production.yml is not in git unless push_instance_config is true.
set :scm, :git
set :repository, "git://github.com/meesern/What-Happened.git"
set :deploy_via, :remote_cache

# Easier to do system level config as root - probably should do it through
# sudo in the future.  We use ssh keys for access, so no passwd needed
set :user, 'root'
set :password, nil

# Use sudo with user rails for cap deploy:[stop|start|restart]
# This way exposed services (mongrel) aren't running as a privileged user
set :use_sudo, true

# How many old releases should be kept around when running "cleanup" task
set :keep_releases, 3

# Lets us work with staging instances without having to checkin config files
# (instance*.yml + rubber*.yml) for a deploy.  This gives us the
# convenience of not having to checkin files for staging, as well as 
# the safety of forcing it to be checked in for production.
#set :push_instance_config, RUBBER_ENV != 'production'
set :push_instance_config, true

# Allows the tasks defined to fail gracefully if there are no hosts for them.
# Comment out or use "required_task" for default cap behavior of a hard failure
rubber.allow_optional_tasks(self)
# Wrap tasks in the deploy namespace that have roles so that we can use FILTER
# with something like a deploy:cold which tries to run deploy:migrate but can't
# because we filtered out the :db role
namespace :deploy do
  rubber.allow_optional_tasks(self)
  tasks.values.each do |t|
    if t.options[:roles]
      task t.name, t.options, &t.body
    end
  end
end

# load in the deploy scripts installed by vulcanize for each rubber module
Dir["#{File.dirname(__FILE__)}/rubber/deploy-*.rb"].each do |deploy_file|
  load deploy_file
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :db do
  desc "Run a task on a remote server"
  # run like: cap staging rake:invoke task=a_certain_task
  task :seed do
    ENV['task']="db:seed"
    rake.invoke
  end
end

namespace :rake do
  desc "Run a task on a remote server"
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    path = deploy_to+"/current" 
    path = release_path unless remote_file_exists?(path)
    run("cd #{path}; /usr/bin/env bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end

#RNM Add backgroundrb tasks
desc <<-DESC
Stop the backgroundrb server
DESC
task :stop_backgroundrb , :roles => :app do
  run "cd #{current_path} && bundle exec ./script/backgroundrb stop"
end

desc <<-DESC
Start the backgroundrb server
DESC
task :start_backgroundrb , :roles => :app do
  run "cd #{current_path} && bundle exec ./script/backgroundrb start"
end

desc <<-DESC
Start the backgroundrb server
DESC
task :restart_backgroundrb , :roles => :app do
  stop_backgroundrb
  start_backgroundrb
end


after "deploy", "deploy:cleanup"
#RNM extend deploy cold to initialise database
after "deploy", "restart_backgroundrb"
after "rubber:create_staging", "db:seed" 
after "rubber:create_staging", "start_backgroundrb" 

