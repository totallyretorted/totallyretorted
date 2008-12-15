class DropRetortIdFromAttributions < ActiveRecord::Migration
  def self.up
    remove_column :attributions, :retort_id
    remove_column :ratings, :retort_id
  end

  def self.down
    change_table :attributions do |t|
      t.integer :retort_id
    end
    
    change_table :ratings do |t|
      t.integer :retort_id
    end
  end
end
