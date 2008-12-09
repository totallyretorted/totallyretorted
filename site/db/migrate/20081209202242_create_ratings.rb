class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :positive
      t.integer :negative
      t.timestamps      
    end
    change_table :retorts do |t|
      t.references :rating
    end
  end

  def self.down
    drop_table :ratings
  end
end
