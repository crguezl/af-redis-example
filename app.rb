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

  @time = Time.now.to_s
  
  @notes = redis.lrange("notes", 0, -1)

  if @notes.length >= 1
    @exists = "addBorder"
  end
  
  haml :index
end

post '/newnote' do
  if params[:newNote].length >= 1
    # @newNote = params[:newNote]
    redis.rpush("notes", params[:newNote])
  end

  redirect '/'
end

post '/sortalpha' do
  @notes = redis.sort("notes", alpha)

  haml :index
end

post '/deleteNote' do
  @noteToDelete = redis.lindex("notes", params[:deleteNote])

  redis.lrem("notes", @noteToDelete)

  redirect '/'
end

post '/' do
  @notes = redis.lrange("notes", 0, -1)

  redis.flushall

  redirect '/'
end