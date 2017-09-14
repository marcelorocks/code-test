require 'bundler'
require 'json'
require 'yaml'
Bundler.require
require './settings.rb'
Dir["./lib/*.rb"].each {|file| require file }
APP_ENV = 'dev'

# App starts with the interface object
interface = Interface.new
interface.run
