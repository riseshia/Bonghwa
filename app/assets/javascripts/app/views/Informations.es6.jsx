class Informations extends React.Component {
  constructor(props) {
    super(props)
    this.clkInfos = this.clkInfos.bind(this)
  }

  information(idx, text) {
    const nodes = [`${idx}. `]

    text.split(" ").forEach(token => {
      nodes.push([
        " ",
        ReactAutolink.autoLink(token, { target: "_blank", rel: "nofollow"})
      ])
    })
    return nodes
  }
  renderInfos() {
    return this.props.infos.map((info, idx) => {
      const infoNodes = this.information(idx + 1, info.information)
      return (
        <div key={`info-${info.id}`}>
          { infoNodes }
        </div>
      )
    })
  }

  render() {
    if (!this.props.infosVisible || this.props.infos.length === 0) {
      return null
    }

    return (
      <div id="info" className="col-md-12 top-fixed" onClick={this.clkInfos}>
        <h4 className="hidden-xs">{ "Information" }</h4>
        { this.renderInfos() }
      </div>
    )
  }

  clkInfos() {
    $("#info").slideUp()
    app.infosVisible = false
  }
}
