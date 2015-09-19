require 'bundler/setup'
require_relative 'directory_scraper'
require 'json'

result = DirectoryScraper.parse
string = JSON.pretty_generate(result)

File.open('fcc_directory.json', 'w') {|f| f.write(string) }
