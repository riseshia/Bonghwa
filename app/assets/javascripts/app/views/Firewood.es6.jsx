class Firewood extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      subfws: props.parents,
      isImgOpened: this.props.defaultIsImgOpened,
      isTextOpened: false,
      isLoading: false
    }
    this.handleDelete = this.handleDelete.bind(this)
    this.handleClickUsername = this.handleClickUsername.bind(this)
    this.handleToggleSubView = this.handleToggleSubView.bind(this)
    this.unFold = this.unFold.bind(this)
    this.fold = this.fold.bind(this)
  }

  componentWillUpdate(nextProps, nextState) {
    if(this.props.defaultIsImgOpened !== nextProps.defaultIsImgOpened) {
      nextState.isImgOpened = nextProps.defaultIsImgOpened
    }
  }

  deletable() {
    if (Number($.cookie("user_id")) == this.props.user_id) {
      return (
        <a href="#"
           onClick={this.handleDelete}
           className="delete">
          {"[x]"}
        </a>
      )
    }
  }

  isLoading() {
    if (this.state.isLoading) {
      return <span className="blinking">{" 로딩중입니다."}</span>
    } else {
      return null
    }
  }

  isMtTarget(token) {
    if (token.length < 3) { return false }
    return token[0] === "@" || token[0] === "!"
  }

  isOpened() {
    return this.state.isImgOpened || this.state.isTextOpened
  }

  highlightMyName(name) {
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

  render() {
    const contentsNodes = this.props.contents.split(" ").
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

    const style = {}
    if (!this.isOpened()) {
      style.display = "none"
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
              </a>{ " : " }<span className="fw-contents">
                { contentsNodes }
                { this.imageInfoTag() }
              </span>
              { this.deletable() }
              { this.isLoading() }
            </div>
            <div className="fw-sub" style={style}>
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
    return (
      <SubFirewood
        isTextOpened={ this.state.isTextOpened }
        isImgOpened={ this.state.isImgOpened }
        firewoods={ this.state.subfws }
        imgLink={ this.props.img_link }
      />
    )
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
    const targets = this.props.mentioned
    const arr = targets.filter(target => !target.endsWith(userName))
    arr.unshift((this.props.is_dm == 0 ? "@":"!") + this.props.name)

    window._appendMt(_.uniq(arr), this.props.id, this.props.root_mt_id)
  }

  handleToggleSubView (event) {
    event.stopPropagation()

    if ( this.props.prev_mt_id === 0 &&
         this.props.img_link === "0" ) {
      // Do nothing
    } else if ( this.isOpened() ) {
      this.fold()
    } else {
      this.unFold()
    }
  }

  fold() {
    const $el = $(`div[data-id=${this.props.id}]`)
    $el.find(".fw-sub").slideUp(() => {
      this.setState({isTextOpened: false, isImgOpened: false})
    })
  }

  ajaxMtLoad() {
    const rootMtId = this.props.root_mt_id
    return $.get(`/api/get_mt.json?root_mt_id=${rootMtId}`)
  }

  unFold() {
    if (this.state.isLoading) { return }
    const $el = $(`div[data-id=${this.props.id}]`)
    const subfws = this.state.subfws
    const noRoot = subfws.filter(fw => fw.id === this.props.root_mt_id)
                         .length === 0

    if (this.props.prev_mt_id !== 0 && noRoot) {
      this.setState({isLoading: true})

      this.ajaxMtLoad().then(json => {
        this.setState({
          subfws: json.fws,
          isImgOpened: true,
          isTextOpened: true,
          isLoading: false
        })
      })
    } else {
      this.setState({isImgOpened: true, isTextOpened: true})
    }
  }
}
