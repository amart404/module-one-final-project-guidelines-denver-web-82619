require 'bundler'
require 'csv'
require 'sinatra/activerecord'
require 'require_all'
require 'tty-prompt'
require 'tty-box'
require 'paint'
require_all 'lib'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil

