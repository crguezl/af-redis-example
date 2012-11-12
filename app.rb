require 'rubygems'
require 'sinatra'
require 'redis'
require 'redis-namespace'
require 'haml'
require 'json'

#configure do
#  services = JSON.parse(ENV['VCAP_SERVICES'])
#  redis_key = services.keys.select { |svc| svc =~ /redis/i }.first
#  redis = services[redis_key].first['credentials']
#  redis_conf = { :host => redis['hostname'], :port => redis['port'], :password => redis['password'] }
#  @@redis = Redis.new redis_conf
#end


x = 10
redis = Redis.new

r = Redis::Namespace.new(:ns, :redis => @r)

before do
  @length = r.LLEN("notes")
  @title = "Sinatra + Redis + AppFog = WIN"
end

get '/' do
  @notes = r.LRANGE("notes", 0, -1)
  haml :index
end

post '/insertNote' do
  if params[:newNote] && params[:newNote].length >= 1
    newNote = params[:newNote]
    r.LPUSH("notes", newNote)
    redirect to '/'
  else
    redirect to '/'
  end
end

delete '/' do
  r.DEL("notes")
  redirect to '/'
end