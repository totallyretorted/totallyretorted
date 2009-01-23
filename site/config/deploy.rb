# added to work around 'stdin: is not a tty' error
default_run_options[:pty] = true

set :application, "retorted"
set :user, "retorted"
set :port, 4222

set :repository,  "https://development.forwardecho.com/repos/retorted/trunk/site/"
set :repository_root, "https://development.forwardecho.com/repos/retorted"
set :repository_module, "/site"

set :deploy_to, "/var/webapps/rails/#{application}"
set :deploy_via, :copy

set :location, "totallyretorted.com"
role :app, location
role :web, location
role :db,  location, :primary => true

set :scm_username, "capistrano"
set :scm_password, "capistrano"
set :use_sudo, false

# user that will start the mongrel instance(s)
set :runner, user

namespace :deploy do
  task :tag do
    set :repository, "#{repository_root}/tags/#{ENV['tag']}/#{repository_module}"
    puts "setting repository to: #{repository}"
    update
  end
  
  task :trunk do
    set :repository, "#{repository_root}/trunk/#{repository_module}"
    puts "setting repository to: #{repository}"
    update
  end
  
  task :branch do
    set :repository, "#{repository_root}/branches/#{ENV['branch']}/#{repository_module}"
    puts "setting repository to: #{repository}"
    update
  end
end