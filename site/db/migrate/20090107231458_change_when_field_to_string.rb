class ChangeWhenFieldToString < ActiveRecord::Migration
  def self.up
    remove_column :attributions, :when
    add_column :attributions, :when, :string
  end

  def self.down
    remove_column :attributions, :when
    add_column :attributions, :when, :date
  end
end
