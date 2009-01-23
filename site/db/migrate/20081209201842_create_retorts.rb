class CreateRetorts < ActiveRecord::Migration
  def self.up
    create_table :retorts do |t|
      t.string :content, :length => 5000      
      t.timestamps
      t.references :attribution
    end
  end

  def self.down
    drop_table :retorts
  end
end
