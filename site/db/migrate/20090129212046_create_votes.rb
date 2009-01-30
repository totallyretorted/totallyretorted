class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user, :retort
      t.integer :value, :default => 1
      t.timestamps
    end
    add_index :votes, [:user_id, :retort_id], :unique => true
  end

  def self.down
    drop_table :votes
  end
end
