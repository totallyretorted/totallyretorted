class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :positive, :default => 0
      t.integer :negative, :default => 0
      t.timestamps      
    end
    change_table :retorts do |t|
      t.references :rating
    end
  end

  def self.down
    remove_column :retorts, :rating_id
    drop_table :ratings
  end
end
