class MobileUsers extends React.Component {
  constructor(props) {
    super(props)
  }

  renderTitle() {
    return `접속자(${this.props.users.length}명)`
  }

  renderUsers() {
    return this.props.users.map(user => {
      return (
        <dd key={user.name}>
          <User name={user.name} clkUsername={this._clkUsername}/>
        </dd>
      )
    })
  }

  render() {
    const title = this.renderTitle()
    const userNodes = this.renderUsers()
    return (
      <div>
        <div id="users-header-mobile">접속자수({title})</div>
        <dl id="users-body-mobile">
          {userNodes}
        </dl>
      </div>
    )
  }

  _clkUsername() {
    const arr = [`@${this.props.name}`]
    window._appendMt(arr)
    $("#mobileNavmenu").offcanvas("hide")
  }
}
