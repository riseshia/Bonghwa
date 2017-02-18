class SubFirewood extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div>
        {this.textsRender()}
        {this.imgRender()}
      </div>
    )
  }

  imgClass() {
    const $window = $(window)
    return $window.width() > $window.height() ? "img-standard" : "img-mobile"
  }

  textsRender() {
    if (!this.props.isTextOpened) { return }
    return this.props.firewoods.map(firewood => this.textRender(firewood))
  }

  imgRender() {
    if (!this.props.isImgOpened) { return }
    if (!this.props.imgLink) { return }

    return (
      <div className="img-content">
        <img className={ this.imgClass() } src={ this.props.imgLink }></img>
        <p><small>
          <a href={ this.props.imgLink }
             className="link_url"
             target="_blank">크게 보기</a>
        </small></p>
      </div>
    )
  }

  unescaped_contents(firewood) {
    return firewood.contents.replace("&lt;", "<").replace("&gt;", ">")
  }

  imageInfoTag(firewood) {
    if (!firewood.image_url) { return }
    if (firewood.image_adult_flg) {
      return (
        <span className="has-image text-warning">
          {`[후방주의 ${firewood.id}] `}
        </span>
      )
    } else {
      return (
        <span className="has-image">
          {`[이미지 ${firewood.id}] `}
        </span>
      )
    }
  }

  textRender(firewood) {
    const contentsNodes =
      this.unescaped_contents(firewood).split(" ").
      map(token => {
        return [
          ReactAutolink.autoLink(token, { target: "_blank", rel: "nofollow" }),
          " "]
      })

    return (
      <li key={firewood.id} className="list-group-item div-mention">
        <div className="mt-trace">
          <small>
            <a href="#">{ firewood.name }</a>{ ": " }
            <span className="fw-contents">
              { contentsNodes }
              { this.imageInfoTag(firewood) }
              <a href="#" className="delete"></a>
            </span>
          </small>
          <small className="pull-right">{ firewood.created_at }</small>
        </div>
      </li>
    )
  }
}
