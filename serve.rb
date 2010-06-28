require "rubygems"
require "sinatra"
require "haml"
require "sass"
require 'game_of_life'

before do headers "Content-Type" => "text/html; charset=utf-8" end

get '/style.css' do content_type 'text/css', :charset => 'utf-8'; sass :style; end

get "/" do 
  @game = GameOfLife.new
  haml :home
end