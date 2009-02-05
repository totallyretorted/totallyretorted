require Dir.glob("./db/migrate/*create_ratings*")[0]

class GetRidOfRatings < ActiveRecord::Migration
  def self.up
    CreateRatings.down
  end

  def self.down
    CreateRatings.up
  end
end
