require 'rubygems'
require 'sinatra'
require 'redis'
require 'haml'
require 'json'

configure do
    services = JSON.parse(ENV['VCAP_SERVICES'])
    redis_key = services.keys.select { |svc| svc =~ /redis/i }.first
    redis = services[redis_key].first['credentials']
    redis_conf = { :host => redis['hostname'], :port => redis['port'], :password => redis['password'] }
    @@redis = Redis.new redis_conf
end

before do
  @length = @@redis.LLEN("notes")
  @time = Time.now.to_s
  @title = "Sinatra + Redis + AppFog = WIN"
end

get '/' do
  @notes = @@redis.LRANGE("notes", 0, -1)

  haml :index
end

post '/newNote' do
  if params[:newNote].length >= 1
    @newNote = params[:newNote]
    @@redis.LPUSH("notes", @newNote)
  end

  redirect '/'
end

post '/deleteNotes' do
  @@redis.FLUSHALL

  redirect '/'
end