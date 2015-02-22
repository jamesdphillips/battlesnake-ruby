require 'sinatra'
require 'oj'
require 'hashie'
require 'active_support/all'
require './utils'

configure do
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)

  puts "redis", REDIS.inspect
end

before do
  @body = request.body.read
  @json = Hashie::Mash.new(Oj.load(@body))
  @game = Hashie::Mash.new(Oj.load(REDIS.get("game.#{@json.game_id}") || "{}"))
end

post '/start' do
  REDIS.set "game.#{@json.game_id}", @body

  return {
    name: "Hungry Hungry Hodor",
    head_url: "http://i.imgur.com/ydglJcJ.png",
    color: "salmon",
    taunt: "Hodor!",
  }.to_json;
end

post '/move' do
  move = Utils.find_direction(@json, @game)
  REDIS.set("game.#{@json.game_id}", @game.to_json)

  return {
    move: move
  }.to_json
end

post '/end' do
  settings.game_states.delete(@json.game_id)
  halt 200
end
