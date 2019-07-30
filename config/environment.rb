require 'bundler'
require "tty-prompt"
require "require_all"

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app'
@prompt = TTY::Prompt.new
ActiveRecord::Base.logger = nil
