require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

get "/" do
  # File.read "public/template.html"
  @title = "Troy's Sherlock Page"
  @toc = File.readlines("data/toc.txt", chomp: true)
  erb :home
end

get "/chapters/:chap" do |chap|
  @title = "Chapter #{chap}"
  @toc = File.readlines("data/toc.txt", chomp: true)
  @chapter = File.read("data/chp#{chap}.txt")
  erb :chapter
end
