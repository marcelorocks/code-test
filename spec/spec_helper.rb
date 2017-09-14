require 'bundler'
require 'json'
require 'yaml'
Bundler.require
require './settings.rb'
Dir["./lib/*.rb"].each {|file| require file }
APP_ENV = 'test' unless defined?(APP_ENV)


def test_data
  [
    {"_id" => 10010, "state" => "NY", "city" => "New York", "pop": 10000},
    {"_id" => 94043, "state" => "CA", "city" => "Mountain View", "pop": 2000000},
    {"_id" => 94551, "state" => "CA", "city" => "Livermore", "pop": 3000000},
    {"_id" => 94552, "state" => "CA", "city" => "Livermore", "pop": 40000000}
  ].map(&:to_json).join("\n")
end
