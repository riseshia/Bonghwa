class SubFirewood extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    const textNodes = this.props.firewoods.map(firewood => {
      return this.textRender(firewood)
    })
    return (
      <div>
        {textNodes}
        {this.imgRender()}
      </div>
    )
  }

  imgClass() {
    const $window = $(window)
    return $window.width() > $window.height() ? "img-standard" : "img-mobile"
  }

  imgRender() {
    if (this.props.imgLink == "0") { return }

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

  textRender(firewood) {
    return (
      <li key={firewood.id} className="list-group-item div-mention">
        <div className="mt-trace">
          <small>
            <a href="#">{ firewood.name }</a> :
            <span className="fw-contents">
              { firewood.contents }
              <a href="#" className="delete"></a>
            </span>
          </small>
          <small className="pull-right">{ firewood.created_at }</small>
        </div>
      </li>
    )
  }
}
