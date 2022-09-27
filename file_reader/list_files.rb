require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

get "/" do
  @files = IO.read("|ls -F public/")
             .split("\n")
             .select { |f| f[-1] != '/' }
             .sort
  @files.reverse! if params[:sort] == "desc"
  erb :files
end

