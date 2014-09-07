require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => "postgresql",
  :host => "localhost",
  :username => "shotaro",
  :database => "micro_blog"
})

ActiveRecord::Base.logger = Logger.new(STDOUT)