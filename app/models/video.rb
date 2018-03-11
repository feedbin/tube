class Video < ApplicationRecord

  def self.new_from_api(account, data)
    Video.new(
      youtube_id: data.id,
      cloudkit_id: account.cloudkit_id,
      video_published_at: data.snippet.published_at,
      data: data.to_h
    )
  end

  def mark_watched!
    self.update(watched: true)
  end

  def duration_in_seconds
    duration = data["content_details"]["duration"]
    match = duration.match %r{^P(?:|(?<weeks>\d*?)W)(?:|(?<days>\d*?)D)(?:|T(?:|(?<hours>\d*?)H)(?:|(?<min>\d*?)M)(?:|(?<sec>\d*?)S))$}
    weeks = (match[:weeks] || '0').to_i
    days = (match[:days] || '0').to_i
    hours = (match[:hours] || '0').to_i
    minutes = (match[:min] || '0').to_i
    seconds = (match[:sec]).to_i
    (((((weeks * 7) + days) * 24 + hours) * 60) + minutes) * 60 + seconds
  end

  def poster_frame
    thumbnails = data.dig("snippet", "thumbnails",)
    thumbnails.dig("maxres", "url") ||  thumbnails.dig("standard", "url")
  end

  def hd
    data.dig("content_details", "definition") == "hd"
  end

  private

    def cache_key
      if persisted?
        super
      else
        youtube_id
      end
    end

end
