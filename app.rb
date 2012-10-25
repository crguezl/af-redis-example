require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'

redis = Redis.new#(:port => VCAP_SERVICES)

before do
  @length = redis.LLEN("notes")
  @time = Time.now.to_s
  @title = "Sinatra + Redis + AppFog = WIN"
end

get '/' do
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

post '/deleteNotes' do
  redis.FLUSHALL

  redirect '/'
end