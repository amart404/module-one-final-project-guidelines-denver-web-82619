require_relative 'config/environment'
require 'sinatra/activerecord/rake'
require 'csv'
require 'sqlite3'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc "parse csv"

task :csv do 
  db = SQLite3::Database.new("db/development.db")
  db.execute("CREATE TABLE IF NOT EXISTS players (
    id INTEGER PRIMARY KEY,
    name,
    position,
    points
  )")

  csv_text = File.read("18_def.csv")
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    db.execute("INSERT INTO players (
      name,
      position,
      points
      ) VALUES(?, ?, ?)",
      row["name"], row["position"], row["points"]
      )
  end
end