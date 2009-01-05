namespace :data do
  task (:base_load_data => :environment) do
  end
  
  desc "load base data from a spreadsheet"
  task (:load_from_spreadsheet => :base_load_data) do
  end
  
  desc "load base data from google spreadsheets"
  task (:load_from_google => :base_load_data) do
  end
  
  desc "load base data from fixtures"
  task (:load_from_fixtures => :base_load_data) do
    dir = ENV['directory'] || ENV['dir'] || "#{RAILS_ROOT}/db/data/fixtures"
    require 'active_record/fixtures'
    Fixtures.create_fixtures(dir, %w{ attributions ratings retorts tags retorts_tags })
  end
  
  desc "load base data from a CSV; assumes header row and appropriately named columns" 
  task (:load_from_csv => :base_load_data) do
    file = ENV['file'] || "#{RAILS_ROOT}/db/data.csv"
    require 'fastercsv'
    options = {}
    options[:headers] = :first_row
    FasterCSV.foreach(file, options) do |row|
      retort = Retort.new(:content => row["retort"])
      row["tags"].split(/,\s*/).each do |tag|
        retort.tags << Tag.find_or_create_by_value(tag)
      end
      retort.rating = Rating.new(:positive => 1)
      if(row["who"] or row["what"] or row["where"] or row["when"] or row["how"])
        a = Attribution.new
        a.who = row["who"]
        a.when = row["when"]
        a.what = row["what"]
        a.where = row["where"]
        a.how = row["how"]
        retort.attribution = a
      end
      retort.save
    end
    puts "loading CSV #{file}"
  end
end