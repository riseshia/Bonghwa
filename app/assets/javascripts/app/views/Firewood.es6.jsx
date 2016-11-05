class Firewood extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      subfws: [],
      isOpened: this.props.defaultIsOpened
    }
    this.handleDelete = this.handleDelete.bind(this)
    this.handleClickUsername = this.handleClickUsername.bind(this)
    this.handleToggleSubView = this.handleToggleSubView.bind(this)
    this.unFold = this.unFold.bind(this)
    this.fold = this.fold.bind(this)
  }

  componentWillUpdate(nextProps, nextState) {
    if(this.props.defaultIsOpened !== nextProps.defaultIsOpened) {
      nextState.isOpened = nextProps.defaultIsOpened
    }
  }

  deletable() {
    if (Number($.cookie("user_id")) == this.props.user_id) {
      return (<a href="#"
                 onClick={this.handleDelete}
                 className="delete">[x]</a>)
    }
  }

  isMtTarget (token) {
    if (token.length < 3) { return false }
    return token[0] === "@" || token[0] === "!"
  }

  highlightMyName (name) {
    const myName = $.cookie("user_name")

    if (name === "@" + myName || name === "!" + myName) {
      return (
        <strong>{name}</strong>
      )
    } else {
      return name
    }
  }

  imageInfoTag() {
    if (this.props.img_link === "0") {
      return
    }
    if (this.props.img_adult_flg) {
      return (
        <span className="has-image text-warning">
          {`[후방주의 ${this.props.img_id}] `}
        </span>
      )
    } else {
      return (
        <span className="has-image">
          {`[이미지 ${this.props.img_id}] `}
        </span>
      )
    }
  }

  unescaped_contents() {
    return this.props.contents.replace("&lt;", "<").replace("&gt;", ">")
  }

  render() {
    const contentsNodes = this.unescaped_contents().split(" ").
    map(token => {
      if (_.isString(token) && this.isMtTarget(token)) {
        return (
          [<span className="mt-target">
             {this.highlightMyName(token)}
           </span>, " "]
        )
      }
      return [ReactAutolink.autoLink(token, { target: "_blank", rel: "nofollow"}), " "]
    })

    let classes = "row firewood mt-to"
    if (this.props.is_dm > 0) {
      classes += " is_dm"
    }

    return (
      <li className="list-group-item div-firewood">
        <div className={ classes }
             data-id={ this.props.id }
             onClick= { this.handleToggleSubView }>
          <div className="col-md-10 fw-cnt">
            <div className="fw-main">
              <a className="fw-username mt-clk"
                 href="#"
                 onClick={this.handleClickUsername}>
                { this.props.name }
              </a> : <span className="fw-contents">
                { contentsNodes }
                { this.imageInfoTag() }
              </span>
              { this.deletable() }
            </div>
            <div className="fw-sub">
              { this.renderSubView() }
            </div>
          </div>
          <div className="col-md-2 time">
            <small>{ this.props.created_at }</small>
          </div>
        </div>
      </li>
    )
  }

  renderSubView() {
    if (this.state.isOpened) {
      return (
        <SubFirewood
          firewoods={ this.state.subfws }
          imgLink={ this.props.img_link }
        />
      )
    }
  }

  handleDelete (event) {
    event.stopPropagation()
    const $self = $(event.target)
    const dataId = this.props.id
    const really = confirm("정말 삭제하시겠어요?")

    if ( !really ) {
      return false
    }

    $.ajax({
      url: `/api/destroy?id=${dataId}`,
      type: "delete",
      dataType: "json"
    }).then(() => {
      $self.parent().parent().parent().parent().remove()
    })
  }

  handleClickUsername (event) {
    event.preventDefault()
    event.stopPropagation()

    const userName = $.cookie("user_name") 
    const $this = $(event.target).parent().parent().parent().parent()
    const targets = $this.find(".mt-target")
    const arr = targets
                  .toArray()
                  .map(target => $(target).text())
                  .filter(target => !target.endsWith(userName))
    arr.unshift((this.props.is_dm == 0 ? "@":"!") + this.props.name)

    window._appendMt(_.uniq(arr), this.props.id)
  }

  handleToggleSubView (event) {
    event.stopPropagation()

    if ( this.props.prev_mt === 0 &&
         this.props.img_link === "0" ) {
      // Do nothing
    } else if ( this.state.isOpened ) {
      this.fold()
    } else {
      this.unFold()
    }
  }

  fold() {
    const $el = $(`div[data-id=${this.props.id}]`)
    $el.find(".fw-sub").slideUp(() => {
      this.setState({isOpened: false})
    })
  }

  ajaxMtLoad() {
    const prev_mt = this.props.prev_mt
    return $.get(`/api/get_mt.json?prev_mt=${prev_mt}`)
  }

  unFold() {
    const fws = app.firewoods.getPreviousFws(this.props.prev_mt, 5)
    const $el = $(`div[data-id=${this.props.id}]`)

    if ( this.props.prev_mt !== 0 && fws.length === 0 ) {
      $("<div class='loading' style='display:none;'>로딩중입니다.</div>")
        .insertAfter($el.find(".fw-main")).slideDown(200)

      this.ajaxMtLoad().then(json => {
        this.setState({subfws: json.fws, isOpened: true})
        $el.find(".loading").remove()
        setTimeout(() => {
          $el.find(".fw-sub").slideDown(200)
        }, 0)
      })
    } else {
      const subFws = fws.map(fw => fw.toJSON())
      this.setState({subfws: subFws, isOpened: true})
      setTimeout(() => {
        $el.find(".fw-sub").slideDown(200)
      }, 0)
    }
  }
}
