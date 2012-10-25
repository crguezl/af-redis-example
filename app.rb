require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'

redis = Redis.new

before do
  @length = redis.LLEN("notes")
  @time = Time.now.to_s
end

# configure do
#   redis = Redis.new( :port => VCAP_SERVICES )
# end

get '/' do
  @title = "Sinatra + Redis + AppFog = WIN"
  @notes = redis.LRANGE("notes", 0, -1)

  haml :index
end

post '/newNote' do
  if params[:newNote].length >= 1
    @newNote = params[:newNote]
    redis.LPUSH("notes", @newNote)
  end

  redirect '/'
end

post '/editNote' do

end

post '/deleteNote' do
  redis.LREM("notes", 1, @noteToDelete)

  redirect '/'
end

post '/' do
  @notes = redis.LRANGE("notes", 0, -1)

  redis.flushall

  redirect '/'
end