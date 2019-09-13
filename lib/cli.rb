require 'pry'
require 'tty-prompt'
PROMPT = TTY::Prompt.new(symbols: {marker: '🏈'})

class Cli
    def self.welcome
        box = TTY::Box.frame(width: 82, height: 30, border: :thick, align: :center, 
                             style: {fg: :blue, bg: :bright_red}) do 
            "
        /$$$$$$$$ /$$             /$$     /$$                                
       | $$_____/| $$            | $$    |__/                                
       | $$      | $$  /$$$$$$  /$$$$$$   /$$  /$$$$$$   /$$$$$$  /$$$$$$$   
       | $$$$$   | $$ |____  $$|_  $$_/  | $$ /$$__  $$ /$$__  $$| $$__  $$  
      | $$__/   | $$  /$$$$$$$  | $$    | $$| $$  \__/ | $$  \  $$| $$ \   $$  
       | $$      | $$ /$$__  $$  | $$ /$$| $$| $$      | $$  | $$| $$  | $$  
       | $$      | $$|  $$$$$$$  |  $$$$/| $$| $$      |  $$$$$$/| $$  | $$  
       |/$$$$$$$$|__/  \_______/    \___/ /$$_/|__/        \______/ |__/  |__/  
       | $$_____/                      | $$                                  
       | $$        /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$$ /$$   /$$
       | $$$$$    |____  $$| $$__  $$|_  $$_/   |____  $$ /$$_____/| $$  | $$
       | $$__/     /$$$$$$$| $$   \ $$  | $$      /$$$$$$$|  $$$$$$ | $$  | $$
       | $$       /$$__  $$| $$  | $$  | $$ /$$ /$$__  $$ \ ____  $$| $$  | $$
       | $$      |  $$$$$$$| $$  | $$  |  $$$$/|  $$$$$$$ /$$$$$$$/|  $$$$$$$
       |__/        \_______/|__/  |__/    \___/    \_______/|_______/   \ ____ $$
                                                                    /$$  | $$
                                                                   |  $$$$$$/
        /$$$$$$$$                       /$$     /$$                 /$$_/$$/ 
       | $$_____/                      | $$    | $$                | $$| $$  
       | $$        /$$$$$$   /$$$$$$  /$$$$$$  | $$$$$$$   /$$$$$$ | $$| $$  
       | $$$$$    /$$__  $$ /$$__  $$|_  $$_/  | $$__  $$ |____  $$| $$| $$  
       | $$__/   | $$  \  $$| $$  \  $$  | $$    | $$  \  $$  /$$$$$$$| $$| $$  
       | $$      | $$  | $$| $$  | $$  | $$ /$$| $$  | $$ /$$__  $$| $$| $$  
       | $$      |  $$$$$$/|  $$$$$$/  |  $$$$/| $$$$$$$/|  $$$$$$$| $$| $$  
       |__/        \______/   \______/     \___/  |_______/   \_______/|__/|__/  
                                                                             
                                                                             
                                                                             
       "
        end
        print box
        puts "\n"
    end

    def self.team_setup
        is_user = PROMPT.yes?("Are you a returning user?")
        if is_user
            usernames = User.all.map {|user| user.name}.sort.uniq
            old_new = PROMPT.yes?("Would you like to make a new team?")
            if old_new
                team_creator
            else
                @@new_user = PROMPT.select("\nSelect your team:", (usernames))
            end
        else
            team_creator
        end
        final_score
        score_breakdown
        re_draft
    end

    def self.team_creator
        @@new_user = PROMPT.ask("Enter new team name: ", default: ENV['USER'])
        new_team = User.create(name: @@new_user)

        qb = Player.where(position: "QB")
        qb_names = qb.map {|player| player.name}.sort.uniq

        rb = Player.where(position: "RB")
        rb_names = rb.map {|player| player.name}.sort.uniq

        wr = Player.where(position: "WR")
        wr_names = wr.map {|player| player.name}.sort.uniq

        dfns = Player.where(position: "Def")
        dfns_names = dfns.map {|player| player.name}.sort.uniq

        new_qb = PROMPT.select("Select your QB.", (qb_names))
        team_qb = Player.find {|player| player.name == new_qb}
        Team.create(user: new_team, player: team_qb)

        new_rb = PROMPT.select("Select your RB.", (rb_names))
        team_rb = Player.find {|player| player.name == new_rb}
        Team.create(user: new_team, player: team_rb)

        new_wr = PROMPT.select("Select your first WR.", (wr_names))
        team_wr = Player.find {|player| player.name == new_wr}
        Team.create(user: new_team, player: team_wr)

        new_wr2 = PROMPT.select("Select your second WR.", (wr_names))
        team_wr2 = Player.find {|player| player.name == new_wr2}
        Team.create(user: new_team, player: team_wr2)

        new_dfns = PROMPT.select("Select your Defense.", (dfns_names))
        team_dfns = Player.find {|player| player.name == new_dfns}
        Team.create(user: new_team, player: team_dfns)
    end

    def self.final_score
        @@whole_team = Team.all.select{|team| team.user.name == @@new_user}
        player_points = @@whole_team.map {|teammate| teammate.player.points}
        total_points = (player_points.sum.to_f) / (16.0)

        if total_points < 65.0
            puts Paint["\nWatch more football! (Consider re-drafting)", "#830606", :bold]
        elsif total_points > 90.0
            puts Paint["\nNever choose any other team", :green, :bold]
        else
            puts Paint["\nNot bad", :yellow, :bold]
        end
        puts "Predicted team score: #{total_points} points\n"
    end

    def self.score_breakdown
        puts Paint["\nScore Breakdown", "#830606", :bright, :underline]
        @@whole_team.each do |individual|
            temp_score = (individual.player.points.to_f) / (16.0)
            puts "#{individual.player.name}'s score: #{temp_score}"
        end 
        puts ""
    end

    def self.re_draft
        try_again = PROMPT.yes?("Would you like to try again?")
        if try_again
            team_setup
        else
            exit
        end
        puts ""
    end
end



