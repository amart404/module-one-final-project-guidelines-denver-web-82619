require 'pry'
require 'tty-prompt'
PROMPT = TTY::Prompt.new

class Cli
    def self.main_menu
        qb = Player.where(position: "QB")
        qb_names = qb.map {|player| player.name}.sort.uniq

        rb = Player.where(position: "RB")
        rb_names = rb.map {|player| player.name}.sort.uniq

        wr = Player.where(position: "WR")
        wr_names = wr.map {|player| player.name}.sort.uniq

        dfns = Player.where(position: "Def")
        dfns_names = dfns.map {|player| player.name}.sort.uniq

        PROMPT.select("Select your QB.", (qb_names))
        PROMPT.select("Select your RB.", (rb_names))
        PROMPT.select("Select your first WR.", (wr_names))
        PROMPT.select("Select your second WR.", (wr_names))
        PROMPT.select("Select your Defense.", (dfns_names))
    end
end



