class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :value
      t.timestamps
    end
    create_table :retorts_tags, :id=>false do |t|
      t.integer :retort_id
      t.integer :tag_id
    end
    add_index :retorts_tags, [:retort_id, :tag_id], :unique=>true
  end

  def self.down
    drop_table :retorts_tags
    drop_table :tags    
  end
end
