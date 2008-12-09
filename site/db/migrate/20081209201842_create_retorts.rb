class CreateRetorts < ActiveRecord::Migration
  def self.up
    create_table :retorts do |t|
      t.text :content
      
      t.timestamps
    end
  end

  def self.down
    drop_table :retorts
  end
end
