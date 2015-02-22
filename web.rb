require 'sinatra'
require 'oj'
require 'hashie'
require 'active_support/all'
require './utils'

configure do
  REDIS = Redis.new(url: ENV["REDISTOGO_URL"])
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

  if @game.moves.length % 5 === 0
    taunt = ['Hodor!', 'BRB getting wards', '/me hodors', 'Ho- Hodor', 'AAAAAAyYYYyyy lmao'].sample
    return { move: move, taunt: taunt }.to_json
  else
    return { move: move }.to_json
  end
end

post '/end' do
  settings.game_states.delete(@json.game_id)
  halt 200
end
