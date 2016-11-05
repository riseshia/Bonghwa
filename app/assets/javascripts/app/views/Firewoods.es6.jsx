class Firewoods extends React.Component {
  constructor(props) {
    super(props)

    window._updateStackNotice = this._updateStackNotice.bind(this)
    this._flushStack = this._flushStack.bind(this)
    this._isNearBottom = this._isNearBottom.bind(this)

    app.channel.load()
    app.channel.setPullingTimer()
    setInterval(this._isNearBottom, 1000)
  }

  _flushStack() {
    const $title = $("title")
    const $stack = $("#timeline_stack")
    $(".last_top").removeClass("last_top").attr("style", "")
    $(".div-firewood:first").addClass("last_top").attr("style", "border-top-width:3px;")

    const fws = app.firewoods.filter((fw) => {
      return fw.get("state") == -1 && fw.get("img_link") !== "0"
    })
    app.firewoods.flushStack()
    $title.html(this.props.originTitle)
    $stack.html("").slideUp(200)

    if ( localStorage.getItem("auto_image_open") == "1" ) {
      _.each(fws, (fw) => { fw.trigger("unFold") })
    }
  }

  _isNearBottom() {
    const fws = app.firewoods
    const $bottomTarget = $(`.firewood[data-id=${fws.last(5)[0].get("id")}]`)

    if ($bottomTarget.length === 0 ||
        !$bottomTarget.isOnScreen() ||
        app.channel.logGetLock ||
        fws.length < 49 ||
        fws.last().get("id") < 10 ) {
      return false
    }
    app.channel.getLogs()
  }

  _updateStackNotice() {
    const fws = app.firewoods.where({ state: window.FW_STATE.IN_STACK})
    const $title = $("title")
    const $stack = $("#timeline_stack")

    if ( fws.length == 0 ) {
      return false
    }
    $title.html(`${this.props.originTitle} (${fws.length})`)
    $stack
      .html(`<a href='#' id='notice_stack_new'>새 장작이 ${fws.length}개 있습니다.</a>`)
      .slideDown(200)
  }

  render() {
    const fwNodes = this.props.firewoods.map(fw => {
      return (
        <Firewood key={`fw-${fw.get("id")}`} {...fw.toJSON()} defaultIsOpened={this.props.defaultIsOpened} />
      )
    })

    return (
      <div>
        <div id="timeline_stack" onClick={this._flushStack}></div>

        <ul className="list-group" id="timeline">
          {fwNodes}
          <li className="list-group-item">로딩중입니다...</li>
        </ul>
      </div>
    )
  }
}
