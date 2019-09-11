require 'pry'
class Cli

    def self.main_menu
        puts "Please select 1 for QB, 2 for WR, 3 for RB, 4 for Def"
        @@user_selection = gets.chomp.to_i
        if @@user_selection == 1
            all_QBs
            
        end
    end
end

def all_QBs
   qb = Player.where(position: "QB")
   qb.map {|player| player.name}
end



