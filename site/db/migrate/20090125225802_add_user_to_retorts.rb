# overriding the sending of emails...
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.reload
  end

  def after_save(user)
    user.reload
  end
end

class AddUserToRetorts < ActiveRecord::Migration
  def self.up
    # create system user
    #  should not be activated, so no one can log in as them
    pwd = 'k0w@bung@!!1!'
    u = User.new(:login => 'system', :email => 'system@totallyretorted.com', :password => pwd, :password_confirmation => pwd)
    u.save
    
    add_column :retorts, :created_by, :integer, :default => u.id
    add_column :retorts, :updated_by, :integer, :default => u.id
  end

  def self.down
    remove_column :retorts, :created_by
    remove_column :retorts, :updated_by
  end
end
