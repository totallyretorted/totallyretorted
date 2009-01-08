class AddUniqueIndexes < ActiveRecord::Migration
  def self.up
    add_index :retorts, :content, :unique => true
    add_index :tags, :value, :unique => true
  end

  def self.down
    remove_index :retorts, :content
    remove_index :tags, :value
  end
end
