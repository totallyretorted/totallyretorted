class AddRetortIdToAttribution < ActiveRecord::Migration
  def self.up
    change_table :attributions do |t|
      t.integer :retort_id
    end
    
    change_table :ratings do |t|
      t.integer :retort_id
    end
  end

  def self.down
    remove_column :attributions, :retort_id
    remove_column :ratings, :retort_id
  end
end
