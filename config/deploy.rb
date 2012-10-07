require 'bundler/capistrano'
require 'whenever/capistrano'
set :whenever_command, "bundle exec whenever"

#setup multistage environments, https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension
set :stages, <stages>
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, '<appname>'
set :scm, :git
set :repository,  '<repository_location>'


namespace :deploy do
  task :start, :roles => :app, :use_sudo => true do
  end
  task :stop, :roles => :app, :use_sudo => true do
  end
  task :restart, :roles => :app, :use_sudo => true do
  end
end

namespace :database do
  desc "Migrate Database if necessary"
  task :migrate do
    run("cd #{deploy_to}/current; bundle exec rake db:migrate RAILS_ENV=#{rails_env}")
  end

  desc "create database for new install"
  task :create do
    run("cd #{deploy_to}/current;#{sudo} /usr/local/bin/bundle exec rake db:create RAILS_ENV=#{rails_env}")
  end

  desc "grant database user permissions"
  task :perms do
    run("cd #{deploy_to}/current;#{sudo} RAILS_ENV=#{rails_env} /usr/local/bin/bundle exec ruby db/db_perms.rb")
  end
end


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end