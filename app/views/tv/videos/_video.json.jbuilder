json.cache! video do
  json.subtitle "Posted by #{video.data["channel_title"]} on #{video.video_published_at.strftime("%B %e, %Y")}"
  json.timecode video.timecode
  json.full_date video.video_published_at.strftime("%B %e, %Y")
  json.extract! video, :id, :youtube_id, :progress, :watched, :data
end
