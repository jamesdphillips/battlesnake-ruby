require 'sinatra'
require 'json'

$game_states = {};

before do
  @body = request.body.read
  @json = body ? JSON.parse(body) : {}
  @game_state = ($game_states[@json.game_id] ||= @json)
end

post '/start' do
  return {
    name: "Hodor",
    head_url: "http://img.talkandroid.com/uploads/2014/11/hodor.png",
    color: "#fff",
    taunt: "Hordor!",
  }.to_json;
end

post '/move' do
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
