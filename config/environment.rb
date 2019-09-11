require 'bundler'
require 'csv'
require 'sinatra/activerecord'
require 'require_all'
require 'tty-prompt'
require_all 'lib'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')



# binding.pry