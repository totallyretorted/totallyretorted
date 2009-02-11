task :data => ['data:load']

namespace :data do
  task (:base_load_data => :environment) do
  end
  
  desc "migrate and load"
  task(:update => [:base_load_data, 'db:migrate']) do
    invoke 'load'
  end
  
  desc "drop, migrate and load"
  task(:refresh => ['db:drop', :update] ) do
  end
  
  desc "load base data"
  task(:load => :base_load_data) do
    if ENV['file']
      invoke 'load_from_file'
    elsif ENV['dir'] or ENV['directory']
      invoke 'load_from_fixtures'
    elsif ENV['url']
      invoke 'load_from_url'
    else
      invoke 'usage'
    end
  end
  
  task(:usage) do
    puts 'usage: data:<task> param=value [param=value]'
    puts 'available tasks:'
    puts '  load (default)         loads data; requires either a file or a url parameter'
    puts '  update                 migrates and loads; requires either a file or a url parameter'
    puts '  refresh                drops, migrates, and loads; requires either a file or a url parameter'
    puts '  load_from_file         requires file parameter'
    puts '  load_from_url          requires url parameter'
    puts '  load_from_google       requires url parameter to google spreadsheet and optional sheet param of comma-delimited list of worksheet names to load'
    puts '  load_from_spreadsheet  requires file parameter to spreadsheet and optional sheet param of comma-delimited list of worksheet names to load'
    puts '  load_from_fixtures     requires dir parameter to directory containing fixtures'
    puts '  load_from_csv          requires file parameter to valid csv'
  end
  
  desc "load base data from a file"
  task(:load_from_file => :base_load_data) do
    if ENV['file'] =~ /\.xls$/
      invoke 'load_from_spreadsheet'
    else
      invoke 'load_from_csv'
    end
  end

  desc "load base data from a URL"
  task(:load_from_url => :base_load_data) do
    invoke 'load_from_google'
  end
  
  desc "load base data from a spreadsheet"
  task (:load_from_spreadsheet => :base_load_data) do
    puts 'load_from_spreadsheet not implemented'
  end
  
  desc "load base data from google spreadsheets"
  task (:load_from_google => :base_load_data) do
    puts 'load_from_google not implemented'
  end
  
  desc "load base data from fixtures"
  task (:load_from_fixtures => :base_load_data) do
    dir = ENV['directory'] || ENV['dir'] || "#{RAILS_ROOT}/db/data/fixtures"
    require 'active_record/fixtures'
    Fixtures.create_fixtures(dir)
    # Fixtures.create_fixtures(dir, %w{ attributions ratings retorts tags })
  end
  
  desc "load user data"
  task (:load_user_data => :base_load_data) do
    # class UserObserver < ActiveRecord::Observer
    #      def after_create(user)
    #        user.reload
    #      end
    # 
    #      def after_save(user)
    #        user.reload
    #      end
    #    end
    #    
    #    @@ts = [
    #      {:login => 'adam.strickland', :email => 'adam.strickland@gmail.com', :password => 'supragen1us'},
    #      {:login => 'jay.walker', :email => 'mr_calamari@yahoo.com', :password => 'uravag'},
    #      {:login => 'shant.donabedian', :email => 'shantd@gmail.com', :password => 'n0catchphrase'},
    #      {:login => 'bj.ray', :email => 'bjandraney@mac.com', :password => '1amgay'},
    #      {:login => 'alex.jo', :email => 'me@alexjo.net', :password => 'ohsosp1cy'},
    #    ]
    #    @@ts.each do |h|
    #      u = User.new(:login => h[:login], :email => h[:email], :password => h[:password], :password_confirmation => h[:password])
    #      u.save
    #      u.activate!      
    #    end
    #    
    #    pwd = 'k0w@bung@!!1!'
    #    u = User.new(:login => 'system', :email => 'system@totallyretorted.com', :password => pwd, :password_confirmation => pwd)
    #    u.save
  end
  
  desc "load base data from a CSV; assumes header row and appropriately named columns" 
  task (:load_from_csv => [:base_load_data, :load_user_data]) do
    puts "task has been deprecated"
    # admin_user = User.find_by_login('system')
    #   
    #   file = ENV['file'] || "#{RAILS_ROOT}/db/data.csv"
    #   require 'fastercsv'
    #   options = {}
    #   options[:headers] = :first_row
    #   FasterCSV.foreach(file, options) do |row|
    #     retort = Retort.new(:content => row["retort"])
    #     row["tags"].split(/,\s*/).each do |tag|
    #       retort.tags << Tag.find_or_create_by_value(tag)
    #     end
    #     retort.votes << Vote.new(:user => admin_user, :value => 1)
    #     if(row["who"] or row["what"] or row["where"] or row["when"] or row["how"])
    #       a = Attribution.new
    #       a.who = row["who"]
    #       a.when = row["when"]
    #       a.what = row["what"]
    #       a.where = row["where"]
    #       a.how = row["how"]
    #       retort.attribution = a
    #     end
    #     retort.save
    #   end
    #   puts "loading CSV #{file}"
  end
  
  task (:borat) do
    require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
    bq = RetortsHelper::get_lotsa_borat_quotes
    bq.each do |q|
      r = Retort.new(:content => q)
      ['movie','funny','borat','nsfw'].each do |t|
        r.tags << Tag.find_or_create_by_value(t)
      end
      r.attribution = Attribution.new
      r.attribution.who = 'Sacha Baron Cohen, as Boris Sagdiyev'
      r.attribution.what = 'Borat: Cultural Learnings of America for Make Benefit Glorious Nation of Kazakhstan'
      r.attribution.when = '2006'
      r.votes << Vote.new(:user => User.find_by_login('adam.strickland'), :value => 1)
      r.save!
    end
  end
  
  task (:urban_b_tags) do
    require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
    require 'open-uri'
    blist = Hpricot(open('http://www.urbandictionary.com/popular.php?character=B'))
    (blist/'table#columnist li a').each do |e|
      worddef = Hpricot(open("http://www.urbandictionary.com#{e.attributes['href']}"))
      (worddef/'div.definition').each do |e2|
        r = Retort.new(:content => e2.inner_html.strip)
        r.tags << Tag.find_or_create_by_value(e.inner_html)
        r.tags << Tag.find_or_create_by_value('urban dictionary')
        r.tags << Tag.find_or_create_by_value('definition')
        r.attribution = Attribution.new(:what => 'Urban Dictionary')
        r.votes << Vote.new(:user => User.find_by_login('adam.strickland'), :value => 1)
        r.save!
      end
    end
  end
private
  def invoke(taskname)
    Rake::Task["data:#{taskname}"].invoke
  end
end