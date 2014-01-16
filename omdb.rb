require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!
  response = Typhoeus.get("www.omdbapi.com/", :params => {:s => search_str})
  result = JSON.parse(response.body)  
  
  
  
  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  result["Search"].map do |movie_hash|  
  html_str += "<a href=/poster/#{movie_hash["imdbID"]}> <li>Title: #{movie_hash["Title"]}, Year: #{movie_hash["Year"]}</li></a>"
  end
  html_str += "</ul></body></html>" 
end

get '/poster/:imdb' do |imdb_id|
  # id = params[:imdb]
  key = Typhoeus.get("www.omdbapi.com", :params => {:i => "#{imdb_id}"})
  poster_id = JSON.parse(key.body)

  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str += "<h3><img src=#{poster_id["Poster"]}></h3>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end