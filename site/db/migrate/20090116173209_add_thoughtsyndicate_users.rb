# overriding the sending of emails...
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.reload
  end

  def after_save(user)
    user.reload
  end
end

class AddThoughtsyndicateUsers < ActiveRecord::Migration
  @@ts = [
    {:login => 'adam.strickland', :email => 'adam.strickland@gmail.com', :password => 'supragen1us'},
    {:login => 'jay.walker', :email => 'mr_calamari@yahoo.com', :password => 'uravag'},
    {:login => 'shant.donabedian', :email => 'shantd@gmail.com', :password => 'n0catchphrase'},
    {:login => 'bj.ray', :email => 'bjandraney@mac.com', :password => '1amgay'},
    {:login => 'alex.jo', :email => 'me@alexjo.net', :password => 'ohsosp1cy'},
  ]
  
  def self.up
    @@ts.each do |h|
      u = User.new(:login => h[:login], :email => h[:email], :password => h[:password], :password_confirmation => h[:password])
      u.save
      u.activate!      
    end
  end

  def self.down
    @@ts.each do |h|
      User.find_by_login(h[:login]).delete
    end
  end
end
