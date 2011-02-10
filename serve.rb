require "rubygems"
require "sinatra"
require "haml"
require "sass"
require 'game_of_life'

$size = 20
$current = GameOfLife.new($size).randomize
$history = []


before do headers "Content-Type" => "text/html; charset=utf-8" end

get '/style.css' do content_type 'text/css', :charset => 'utf-8'; sass :style; end

get "/" do 
  $history << $current
  $current = $current.evolve
  haml :home
end

get "/async/random" do
  $current = GameOfLife.new($size).randomize
  haml :async, :layout => false
end

get "/async/clear" do
  $current = GameOfLife.new($size)
  haml :async, :layout => false
end

get "/async/custom/:board" do
  linear = params[:board].split("").map{|s| s.to_i} 
  linear.each_with_index do |value, index|
    $current.state[index % $current.size][index / $current.size] = value
  end
  $history << $current
  $current = $current.evolve
  
  haml :async, :layout => false
end

get "/async/previous" do
  $current = $history.pop unless $history.empty?
  haml :async, :layout => false
end

get "/reset" do 
  $history = []
  $current = GameOfLife.new($size)
  redirect "/"
end