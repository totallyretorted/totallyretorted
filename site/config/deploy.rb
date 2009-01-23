# added to work around 'stdin: is not a tty' error
default_run_options[:pty] = true

set :application, "retorted"
set :repository,  "https://development.forwardecho.com/repos/retorted/trunk/site/"
#set :repository,  "https://development.forwardecho.com/repos/retorted/tags/0.1.1/site/"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/retorted/railsapp"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "totallyretorted.com"
role :web, "totallyretorted.com"
role :db,  "totallyretorted.com", :primary => true

set :user, "retorted"
set :scm_username, "capistrano"
set :scm_password, "capistrano"
set :use_sudo, false