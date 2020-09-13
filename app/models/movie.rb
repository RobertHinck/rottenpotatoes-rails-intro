class Movie < ActiveRecord::Base
    
    # returns all the different ratings in the database
    def self.possible_ratings
        self.uniq.pluck(:rating).sort
    end
end
