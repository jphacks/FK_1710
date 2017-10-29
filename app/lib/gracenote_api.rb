require 'bundler/setup'
require 'json'
require 'rest-client'
require 'dotenv'

Dotenv.load

class GracenoteApi
  CLIENT_ID = ENV['CLIENT_ID']
  USER_ID = ENV['USER_ID']
  ENDPOINT = 'https://c16023552.web.cddbp.net/webapi/json/1.0/'

  attr_reader :artist_name, :track_title, :focus_popularity, :focus_similarity, :lang

  def initialize(artist_name, track_title, focus_popularity, focus_similarity, lang)
    @artist_name = artist_name
    @track_title = track_title
    @focus_popularity = focus_popularity
    @focus_similarity = focus_similarity
    @lang = lang
  end

  def rhythm
    call_rhythm_api.dig('RESPONSE', 0, 'ALBUM').map do |item|
      {
          artist: item.dig('ARTIST', 0, 'VALUE'),
          track_title: item.dig('TRACK', 0, 'TITLE', 0, 'VALUE'),
          cover_image: item.dig('URL', 0, 'VALUE')
      }
    end
  end

  def search
    call_web_api.dig('RESPONSE', 0, 'ALBUM').map do |item|
      {
          artist: item.dig('ARTIST', 0, 'VALUE'),
          album: item.dig('TITLE', 0, 'VALUE'),
          track_titles:
              item.dig('TRACK').map do |item|
                item.dig('TITLE', 0, 'VALUE')
              end
      }
    end
  end

  private
  def call_rhythm_api
    url = ENDPOINT + 'radio/create'
    res = RestClient.get url, {
        params: {
            client: CLIENT_ID,
            user: USER_ID,
            lang: lang,
            artist_name: artist_name,
            focus_popularity: focus_popularity,
            focus_similarity: focus_similarity,
            return_count: 20,
            track_title: track_title,
            select_extended: 'cover'
        }
    }
    JSON.parse(res)
  end

  def call_web_api
    xml = "<QUERIES><AUTH><CLIENT>#{CLIENT_ID}</CLIENT><USER>#{USER_ID}</USER></AUTH><LANG>jpn</LANG><QUERY CMD=\"ALBUM_SEARCH\"><TEXT TYPE=\"ARTIST\">#{artist_name}</TEXT><TEXT TYPE=\"TRACK_TITLE\">#{track_title}</TEXT></QUERY></QUERIES>"
    res = RestClient.post ENDPOINT, xml, { context_type: :xml }
    JSON.parse(res)
  end
end
