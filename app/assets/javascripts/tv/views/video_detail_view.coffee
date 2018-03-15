this.videoDetailView = (video) ->

  hd = ->
    if video.hd
      hd = """
      <badge src="resource://hd" />
      """
    else
      ""

  duration = ->
    seconds = video.duration_in_seconds
    if seconds < 60
      "#{seconds} sec"
    else
      minutes = Math.round seconds / 60
      "#{minutes} min"

  formatNumber = (number) ->
    numberFormat = new Intl.NumberFormat()
    numberFormat.format number

  template = """
  
  <document>
    <productTemplate theme="dark">
      <banner>

        <stack>
          <title style="font-size: 45pt;"><![CDATA[#{video.data.snippet.title}]]></title>
          <row>
            <text style="font-weight: bold;"><![CDATA[#{video.data.snippet.channel_title}]]></text>
          </row>
          <row>
            <text><![CDATA[#{duration()}]]></text>
            <text><![CDATA[#{video.full_date}]]></text>
            <text><![CDATA[#{formatNumber(video.data.statistics.view_count)} views]]></text>
            #{hd()}
          </row>

          <description><![CDATA[#{video.data.snippet.description}]]></description>
          <row>
            <buttonLockup action="VideoPlay" videoID="#{video.id}">
              <badge src="resource://button-play" />
              <title>Play</title>
            </buttonLockup>
            <buttonLockup action="ToggleWatched" videoID="#{video.id}" id="watchedButton_#{video.id}">
              <badge src="resource://button-checkmark" />
              <title>#{if video.watched then "Unwatched" else "Watched"}</title>
            </buttonLockup>
          </row>
        </stack>

        <heroImg src="#{video.poster_frame}" style="width: 800pt;" />
      </banner>

    </productTemplate>
  </document>
  """

  parser = new DOMParser();
  view = parser.parseFromString(template, "application/xml");

  view.addEventListener "play", eventHandler
  view.addEventListener "select", eventHandler

  view