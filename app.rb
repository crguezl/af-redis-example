require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'

redis = Redis.new

before do
  @length = redis.llen("notes")
  @exists = "noBorder"
end

# configure do
#   redis = Redis.new( :port => VCAP_SERVICES )
# end

get '/' do
  @title = "Sinatra + Redis + AppFog = WIN"
  
  @notes = redis.lrange("notes", 0, -1)

  if @notes.length >= 1
    @exists = "addBorder"
  end
  
  haml :index
end

post '/newnote' do
  if params[:newNote].length >= 1
    @newNote = params[:newNote]
    redis.rpush("notes", @newNote)
  end

  redirect '/'
end

post '/sortalpha' do
  @notes.sort!

  @notes

  haml :index
end

post '/' do
  @notes = redis.lrange("notes", 0, -1)

  redis.flushall

  redirect '/'
end