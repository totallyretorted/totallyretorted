require 'fastercsv'

class LoadRetortData < ActiveRecord::Migration
  def self.up
    clear_data
    
    FasterCSV.foreach(File.join(File.dirname(__FILE__), "..", "data", ENV['RAILS_ENV'] || 'development', 'retorts.csv'), {:headers => :first_row}) do |row|
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
  end

  def self.down
    clear_data
  end
  
  def self.clear_data
    Retort.delete_all
  end
end
