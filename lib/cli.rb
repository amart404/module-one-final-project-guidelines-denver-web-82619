require 'pry'
require 'tty-prompt'
PROMPT = TTY::Prompt.new

class Cli
    def self.team_setup
        is_user = PROMPT.yes?("Are you a returning user?")
        if is_user
            usernames = User.all.map {|user| user.name}
            new_user = PROMPT.select("Select your team.", (usernames))
        else
            new_user = PROMPT.ask("Enter new team name: ", default: ENV['USER'])
            new_team = User.create(name: new_user)

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
        whole_team = Team.all.select{|team| team.user.name == new_user}
        player_points = whole_team.map {|teammate| teammate.player.points}
        total_points = (player_points.sum.to_f) / (16.0)
        p total_points
    end
end



