class Firewoods extends React.Component {
  constructor(props) {
    super(props)
    this._flushStack = this._flushStack.bind(this)
  }

  _flushStack() {
    const $title = $("title")
    $(".last_top").removeClass("last_top")
    $(".div-firewood:first").addClass("last_top")

    app.FirewoodsFn.flushStack()
    $title.html(this.props.originTitle)
    this.forceUpdate()
  }

  render() {
    let stackNode = null
    const stackCount = this.props.firewoods.filter(fw => !fw.isVisible).length
    if (stackCount > 0) {
      app.Title.render(stackCount)
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
            defaultIsImgOpened={this.props.defaultIsImgOpened}
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
