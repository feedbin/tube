require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'

class GoogleClient

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def channel(channel_id)
    client.list_channels("snippet,contentDetails,statistics", id: channel_id).items.first
  end

  def channel_playlists(channel_id)
    client.list_playlists("snippet,contentDetails", max_results: 50, channel_id: channel_id).items
  end

  def channel_videos(playlist_id, max_results = 5, parts = "snippet,contentDetails,statistics")
    items = client.list_playlist_items("snippet", max_results: max_results, playlist_id: playlist_id).items
    video_ids = items.map {|item| item.snippet.resource_id.video_id }
    client.list_videos(parts, id: video_ids.join(",")).items
  end

  def subscribed_playlist_ids
    @upload_playlist_ids ||= begin
      subscriptions = client.list_subscriptions("snippet", mine: true, max_results: 50)
      channel_ids = subscriptions.items.map { |subscription| subscription.snippet.resource_id.channel_id }
      channels = client.list_channels("contentDetails", id: channel_ids.join(","))
      channels.items.map {|channel| channel.content_details.related_playlists.uploads}
    end
  end

  def client
    @client ||= begin
      scopes = ["https://www.googleapis.com/auth/youtube.readonly"]
      token_store = CredentialStore.new()
      authorizer = Google::Auth::UserAuthorizer.new(GOOGLE_CLIENT_ID, scopes, token_store)
      authorize = authorizer.get_credentials(id)
      service = Google::Apis::YoutubeV3::YouTubeService.new
      service.authorization = authorize
      service
    end
  end

end