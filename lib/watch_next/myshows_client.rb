require 'watch_next/myshows_client/http'

module WatchNext
  class MyshowsClient
    MAX_ATTEMPTS = 3

    Show = Struct.new(
      :id,
      :title,
      :show_status,
      :watch_status,
      :watched_episodes,
      :total_episodes,
      :rating,
      :image
    )

    Episode = Struct.new(
      :id,
      :title,
      :show_id,
      :season_number,
      :episode_number,
      :air_date
    )

    def initialize(username, password_hash, http_client = HTTP.new)
      @username = username
      @password_hash = password_hash
      @http_client = http_client
    end

    def unwatched_episodes
      with_authentication do
        @http_client.unwatched_episodes.map do |episode_id, episode_data|
          Episode.new(
            *episode_data.values_at("episodeId",
                                    "title",
                                    "showId",
                                    "seasonNumber",
                                    "episodeNumber",
                                    "airDate")
          )
        end
      end
    end

    def shows
      with_authentication do
        @http_client.shows.map do |show_id, show_data|
          Show.new(
            *show_data.values_at("showId",
                                 "title",
                                 "show_status",
                                 "watch_status",
                                 "watched_episodes",
                                 "total_episodes",
                                 "rating",
                                 "image")
          )
        end
      end
    end

    private

    def with_authentication
      attempt = 1
      begin
        yield
      rescue HTTP::NotAuthorizedError => e
        raise e if attempt > MAX_ATTEMPTS
        @http_client.authenticate(@username, @password_hash)
        attempt += 1
        retry
      end
    end
  end
end
