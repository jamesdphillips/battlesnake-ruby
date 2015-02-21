require 'sinatra'
require 'oj'
require 'hashie'
require 'active_support/all'
require './utils'

$game_states = {};

before do
  @body = request.body.read
  @json = Hashie::Mash.new(Oj.load(@body))
  @game_state = ($game_states[@json.game_id] ||= @json)
end

post '/start' do
  return {
    name: "Hordor",
    head_url: "http://i.imgur.com/ydglJcJ.png",
    color: "#fff",
    taunt: "Hordor!",
  }.to_json;
end

post '/move' do
  puts "current_game_state", @game_state, $game_states
  move = Utils.find_direction(@json, @game_state)

  return {
    move: move,
    taunt: "Hodor?"
  }.to_json
end

post '/end' do
  $game_states.delete(@game_state.game_id)
  halt 200
end
