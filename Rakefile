require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

if ARGV.grep(/rubber:/).empty?
  require(File.join(File.dirname(__FILE__), 'config', 'boot'))

  env = ENV['RUBBER_ENV'] ||= (ENV['RAILS_ENV'] || 'development')
  RAILS_ENV = ENV['RAILS_ENV'] = env
  root = File.dirname(__FILE__)

  require 'rubber'

  Rubber::initialize(root, env)

  require 'rubber/tasks/rubber'

  task :console do
    ARGV.clear
    require "irb"
    IRB.start
  end

  require 'hobo/tasks/rails'
  require 'tasks/rails'
else
  load File.join(File.dirname(__FILE__), 'lib/tasks/rubber.rake')
end
