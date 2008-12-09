class CreateAttributions < ActiveRecord::Migration
  def self.up
    create_table :attributions do |t|
      t.string :who, :what, :where, :how
      #t.string :what
      t.date :when
      #t.string :where
      #t.string :how
      t.timestamps
    end
  end

  def self.down
    drop_table :attributions
  end
end
