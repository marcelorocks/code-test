require 'bundler'
require 'json'
require 'yaml'
Bundler.require
require './settings.rb'
Dir["./lib/*.rb"].each {|file| require file }

interface = Interface.new
interface.run

# response = JSON.parse(RestClient.get(SETTINGS['data_source']))
