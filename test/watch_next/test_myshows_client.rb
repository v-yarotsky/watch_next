require 'test_helper'

module WatchNext
  class TestMyshowsClient < WatchNextTC
    def setup
      @client = MyshowsClient.new
    end

    def authenticate(username = "demo", password_hash = "fe01ce2a7fbac8fafaed7c982a04e229")
      @client.authenticate(username, password_hash)
    end

    test "authenticate logs user in (success)", vcr: { cassette: "login" } do
      assert authenticate, "expected client to successfully authenticate"
    end

    test "authenticate logs user in (failure)", vcr: { cassette: "login_failure" } do
      assert_raises MyshowsClient::AuthenticationError do
        authenticate("baduser", "worstpassword")
      end
    end

    test "unwatched_episodes raises MyshowsClient::NotAuthorizedError if not authenticated",
         vcr: { cassette: "unathenticated_unwatched_episodes" } do

      assert_raises MyshowsClient::NotAuthorizedError do
        @client.unwatched_episodes
      end
    end

    test "unwatched_episodes fetches data from /profile/episodes/unwatched",
          vcr: { cassette: "autenticated_unwatched_episodes" } do
      episode = {
        "episodeId" => 2169617,
        "title" => "Day 9: 8:00 PM-9:00 PM",
        "showId" => 4,
        "seasonNumber" => 9,
        "episodeNumber" => 10,
        "airDate" => "30.06.2014"
      }
      authenticate
      assert_equal(episode, @client.unwatched_episodes["2169617"])
    end

    test "shows raises MyshowsClient::NotAuthorizedError if not authenticated",
         vcr: { cassette: "unathenticated_shows" } do

      assert_raises MyshowsClient::NotAuthorizedError do
        @client.shows
      end
    end

    test "shows fetches data from /profile/shows",
          vcr: { cassette: "autenticated_shows" } do
      black_mirror = {
        "showId" => 22410,
        "title" => "Black Mirror",
        "ruTitle" => "Черное зеркало",
        "runtime" => 43,
        "showStatus" => "Returning Series",
        "watchStatus" => "watching",
        "watchedEpisodes" => 6,
        "totalEpisodes" => 7,
        "rating" => 4,
        "image" => "http://images.tvrage.com/shows/31/30348.jpg"
      }
      authenticate
      assert_equal(black_mirror, @client.shows["22410"])
    end
  end
end

