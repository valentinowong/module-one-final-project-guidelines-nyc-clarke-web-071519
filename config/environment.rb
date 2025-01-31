require 'bundler'
require "tty-prompt"
require "require_all"
require 'colorize'
require 'rest-client'
require 'json'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app'
ActiveRecord::Base.logger = nil