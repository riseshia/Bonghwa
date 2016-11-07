class Firewoods extends React.Component {
  constructor(props) {
    super(props)

    this._flushStack = this._flushStack.bind(this)
  }

  _flushStack() {
    const $title = $("title")
    $(".last_top").removeClass("last_top")
    $(".div-firewood:first").addClass("last_top")

    app.firewoods.flushStack()
    $title.html(this.props.originTitle)
    app.render()
  }

  _updateStackNotice() {
    const fws = this.props.firewoods.filter(fw => !fw.isVisible)
    const $title = $("title")
    const $stack = $("#timeline_stack")

    if ( fws.length === 0 ) {
      return false
    }
    $title.html(`${this.props.originTitle} (${fws.length})`)
    $stack
      .html(`<a href="#" id="notice_stack_new">새 장작이 ${fws.length}개 있습니다.</a>`)
      .slideDown(200)
  }

  render() {
    let stackNode = null
    const stackCount = this.props.firewoods.filter(fw => !fw.isVisible).length
    if (stackCount) {
      stackNode = (
        <a href="#" id="notice_stack_new">
          {`새 장작이 ${stackCount}개 있습니다.`}
        </a>
      )
    }
    const fwNodes = this.props.firewoods.filter(fw => fw.isVisible)
      .map(fw => {
        return (
          <Firewood
            key={`fw-${fw.id}`}
            {...fw}
            defaultIsOpened={this.props.defaultIsOpened}
          />
        )
      })

    return (
      <div>
        <div id="timeline_stack" onClick={this._flushStack}>
          {stackNode}
        </div>

        <ul className="list-group" id="timeline">
          {fwNodes}
          <li className="list-group-item">로딩중입니다...</li>
        </ul>
      </div>
    )
  }
}
