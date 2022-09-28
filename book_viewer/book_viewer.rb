require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

def chapter_title(chap)
  @toc[chap - 1]
end

def chapter_contents(chap)
  File.read("data/chp#{chap}.txt")
end

before do
  @toc = File.readlines("data/toc.txt", chomp: true)
end

get "/" do
  @title = "Troy's Sherlock Page"

  erb :home
end

get "/chapters/:chap" do |chap|
  redirect "/" unless (1..@toc.size).cover?(chap.to_i)

  @title = "Chapter #{chap}: #{chapter_title(chap.to_i)}"
  @chapter = chapter_contents(chap)

  erb :chapter
end

get "/search" do
  @title = "Search"
  @results = nil

  if params[:query]
    chapters = Dir.glob("data/*.*") - ["data/toc.txt"]
    chapters.map! { |filename| filename.match(/(\d+)/).captures[0].to_i }
            .sort!
            .select! { |chap| chapter_contents(chap).include?(params[:query]) }

    if chapters.any?
      @results = []

      chapters.each do |chap|
        result = {}
        result[:number] = chap
        result[:title] = chapter_title(chap)
        result[:paragraphs] = {}

        chapter_contents(chap).split("\n\n")
                              .each_with_index do |para, idx|
          if para.include?(params[:query])
            result[:paragraphs][idx + 1] = para
          end
        end
        @results << result
      end
    end
  end

  erb :search
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n")
        .map.with_index { |line, idx| "<p id=\"#{idx + 1}\">#{line}</p>" }
        .join
  end

  def highlight_query(para, query)
    para.gsub!(query, "<strong>#{query}</strong>")
  end
end
