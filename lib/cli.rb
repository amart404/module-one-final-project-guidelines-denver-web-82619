require 'pry'
require 'tty-prompt'
PROMPT = TTY::Prompt.new

class Cli
    def self.get_user
        is_user = PROMPT.yes?("Are you a returning user?")
        if is_user
            usernames = User.all.map {|user| user.name}
            prev_user = PROMPT.select("Select your username.", (usernames))
        else
            new_user = PROMPT.ask("Enter new username: ", default: ENV['USER'])
            User.create(name: new_user)
        end
    end

    def self.pick_team

        qb = Player.where(position: "QB")
        qb_names = qb.map {|player| player.name}.sort.uniq

        rb = Player.where(position: "RB")
        rb_names = rb.map {|player| player.name}.sort.uniq

        wr = Player.where(position: "WR")
        wr_names = wr.map {|player| player.name}.sort.uniq

        dfns = Player.where(position: "Def")
        dfns_names = dfns.map {|player| player.name}.sort.uniq

        binding.pry

        new_qb = PROMPT.select("Select your QB.", (qb_names))
        new_rb = PROMPT.select("Select your RB.", (rb_names))
        new_wr = PROMPT.select("Select your first WR.", (wr_names))
        new_wr2 = PROMPT.select("Select your second WR.", (wr_names))
        new_dfns = PROMPT.select("Select your Defense.", (dfns_names))
    end
end



