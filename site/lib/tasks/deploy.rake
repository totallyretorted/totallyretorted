require 'vlad'

module BetterSubversion
  def self.included(base)
    base.class_eval do
      alias_method :old_export, :export unless method_defined?(:old_export)
      alias_method :export, :new_export
      
      alias_method :old_checkout, :checkout unless method_defined?(:old_checkout)
      alias_method :checkout, :new_checkout
    end
  end
  
  def new_checkout(revision, destination)
    "ls"
  end
  
  def new_export(revision_or_source, destination)
    "#{svn_cmd} export #{repository} #{destination}"
  end      
end

namespace :vlad do
  namespace :deploy do
    task :fix_svn do
      Vlad::Subversion.send(:include, BetterSubversion)
    end
    
    task :tag, :name, :needs => :fix_svn do |task, args|
      set :repository,  "#{repository_base}/tags/#{args.name}/#{repository_module}/"
      Rake::Task['vlad:update'].invoke
    end
    
    task :branch, :name, :needs => :fix_svn do |task, args|
      set :repository,  "#{repository_base}/branches/#{args.name}/#{repository_module}/"
      Rake::Task['vlad:update'].invoke
    end
    
    task :trunk, :name, :needs => :fix_svn do |task, args|
      set :repository,  "#{repository_base}/trunk/#{repository_module}/"
      Rake::Task['vlad:update'].invoke
    end
  end
  
  namespace :cluster do
    remote_task :start, :roles => :app do
      run "mongrel_cluster_ctl start"
    end
    
    remote_task :stop, :roles => :app do
      run "mongrel_cluster_ctl stop"
    end
  end
  
  namespace :web do
    remote_task :start, :roles => :app do
      run "sudo #{web_command} start"
    end
    
    remote_task :stop, :roles => :app do
      run "sudo #{web_command} stop"
    end
  end
  
  namespace :app do
    remote_task :start, :roles => :app do
      Rake::Task['vlad:cluster:start'].invoke
      Rake::Task['vlad:web:start'].invoke
    end
    
    remote_task :stop, :roles => :app do
      Rake::Task['vlad:cluster:stop'].invoke
      Rake::Task['vlad:web:stop'].invoke
    end
  end
    
  
  # remote_task :do_tag, :roles => :app do
  #    symlink = false
  #    temppath = "#{scm_path}/../"
  #    begin
  #      run [
  #        "cd #{temppath}",
  #        "#{source.export('head', release_path)}",
  #      ].join(" && ")
  #    rescue => e
  #      raise e
  #    end
  #  end
  
  # remote_task :update, :roles => :app do
  #     symlink = false
  #     begin
  #       run [ "cd #{scm_path}",
  #             "#{source.export 'head', release_path}",
  #             "chmod -R g+w #{latest_release}",
  #             "rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids",
  #             "mkdir -p #{latest_release}/db #{latest_release}/tmp",
  #             "ln -s #{shared_path}/log #{latest_release}/log",
  #             "ln -s #{shared_path}/system #{latest_release}/public/system",
  #             "ln -s #{shared_path}/pids #{latest_release}/tmp/pids",
  #           ].join(" && ")
  # 
  #       symlink = true
  #       run "rm -f #{current_path} && ln -s #{latest_release} #{current_path}"
  # 
  #       run "echo #{now} $USER #{revision} #{File.basename release_path} >> #{deploy_to}/revisions.log"
  #     rescue => e
  #       run "rm -f #{current_path} && ln -s #{previous_release} #{current_path}" if
  #         symlink
  #       run "rm -rf #{release_path}"
  #       raise e
  #     end
  #   end
end