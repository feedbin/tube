class VideoDetailView extends View {

  constructor(video) {
    super();
    this.video = video;
  }

  template() {
    return `
    <document>
      <productTemplate theme="dark">
        <banner>

          <stack>
            <title style="font-size: 45pt;"><![CDATA[${this.video.data.snippet.title}]]></title>
            <row>
              <text style="font-weight: bold;"><![CDATA[${this.video.data.snippet.channel_title}]]></text>
            </row>
            <row>
              <text><![CDATA[${this.video.duration()}]]></text>
              <text><![CDATA[${this.video.full_date}]]></text>
              <text><![CDATA[${this.video.viewCount()} views]]></text>
              ${this._hd()}
            </row>

            <description><![CDATA[${this.video.data.snippet.description}]]></description>
            <row>
              <buttonLockup action="videoPlay" dataID="${this.video.id}">
                <badge src="resource://button-play" />
                <title>Play</title>
              </buttonLockup>
              ${this._watchedButtonView()}
            </row>
          </stack>

          <heroImg src="${this.video.poster_frame}" style="width: 800pt;" />
        </banner>

      </productTemplate>
    </document>`;
  }

  _watchedButtonView() {
    const view = new WatchedButtonView(this.video);
    return view.template();
  }

  _hd() {
    if (this.video.hd) {
      return `<badge src="resource://hd" />`;
    } else {
      return "";
    }
  }

}
