require 'sinatra'
require 'sinatra/reloader'
require './lib/gracenote_api.rb'
require './lib/rhythm_api_mock.rb'

get '/' do
  erb :top
end

post '/playlist' do
  @musics = GracenoteApi.new(params[:artist], params[:track_title], 1000, 1000, 'jpn').rhythm

  erb :play_list
end

get '/mock' do
  @musics = RhythmApiMock.new('./lib/mock.txt').json

  erb :play_list
end
