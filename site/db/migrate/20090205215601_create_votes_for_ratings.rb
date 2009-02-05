class Retort < ActiveRecord::Base
  belongs_to :rating
end

class Rating < ActiveRecord::Base
  has_one :retort
end

# overriding the sending of emails...
class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.reload
  end

  def after_save(user)
    user.reload
  end
end

class CreateVotesForRatings < ActiveRecord::Migration
  def self.up
    Retort.find(:all).each do |retort|
      j = 333
      if retort.rating
        num_pos = (retort.rating.positive || 0)
        num_votes = num_pos + (retort.rating.negative || 0)
        if num_votes == 0
          num_votes = 1
        end
      else
        num_votes = 1
        num_pos = 1
      end
      
      num_votes.times do |i|
        u = User.find_by_login("vote_user_#{j}")
        if !u
          u = User.new(:login => "vote_user_#{j}", :email => "vote_user_#{j}@totallyretorted.com", :password => "password", :password_confirmation => "password")
          u.save
        end
        
        if i < num_pos
          vote_val = 1
        else
          vote_val = -1
        end
        
        Vote.new(:retort => retort, :user => u, :value => vote_val).save!
        
        j += 1
      end
    end
    
    # add an extra vote to Retort id #1
    Vote.new(:retort => Retort.find_by_id(1), :user => User.find_by_login('adam.strickland'), :value => 1).save!
  end

  def self.down
    Vote.delete_all
    # User.find(:all, :conditions => ["login LIKE ?", 'vote_user_%']).delete
    User.delete_all("login LIKE 'vote_user%'")
  end
end
