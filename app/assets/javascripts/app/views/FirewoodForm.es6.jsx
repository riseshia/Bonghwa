class FirewoodForm extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      maxCount: 150,
      value: "",
      adultCheck: false,
      prevMtId: 0,
      rootMtId: 0
    }

    window.ajaxSuccess = this._formClear.bind(this)
    window._appendMt = this._appendMt.bind(this)
    window._flashForm = this._flashForm.bind(this)
    this._isFormEmpty = this._isFormEmpty.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.handleTextChange = this.handleTextChange.bind(this)
    this.handleCheckboxChange = this.handleCheckboxChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    $("#new_firewood").submit(this.handleSubmit)
    $("span[rel=tooltip]").tooltip()
  }

  render() {
    const commitBtnText = this._isFormEmpty() ? "Refresh" : "Submit"
    const remainingCount = this.state.maxCount - this.state.value.length

    return (
      <fieldset>
        <div className="form-group">
          <div className={"col-sm-12" + (this._isbwTextEmpty() ? " bw-text-empty" : "")}>
            <input
              id="contents"
              className="form-control"
              placeholder="New..."
              autoComplete="off"
              onChange={this.handleTextChange}
              value={this.state.value}
            />
          </div>
        </div>
        <div className="form-group">
          <div className="col-sm-12">
            <div className="fileinput fileinput-new" data-provides="fileinput">
              <span className="btn btn-default btn-file" rel="tooltip" data-placement="right" data-original-title="5MB 이하. jpg, png, gif">
                <span className="fileinput-new">{"Pic"}</span>
                <span className="fileinput-exists">{"Change"}</span>
                <input type="file" name="attach" id="img" accept="image/*" />
              </span>
              <span className="fileinput-filename"></span>
              <a href="#" className="close fileinput-exists" data-dismiss="fileinput">{"×"}</a>
              <input type="checkbox" checked={this.state.adultCheck} id="adult_check" onChange={this.handleCheckboxChange}/>
              <span className="text-warning">{" 후방주의"}</span>
            </div>
            <div className="pull-right" id="div-submit">
              <span id="remaining_count">{remainingCount}</span>
              <input type="submit" name="commit" value={commitBtnText} id="commit" className="btn btn-primary" data-loading-text="Wait...." />
            </div>
          </div>
        </div>
      </fieldset>
    )    
  }

  _formClear() {
    const $form = $("#new_firewood")
    const $commitBtn = $("#commit")

    $form.clearForm()
    $("#img").val("")
    $(".fileinput-preview").html("")
    $(".fileinput")
      .removeClass("fileinput-exists")
      .addClass("fileinput-new")
    $(".fileinput-filename").html("")
    $commitBtn.button("reset")
    this.setState({value: "", prevMtId: 0, rootMtId: 0, adultCheck: false})
  }

  _appendMt(names, targetId = 0, rootMtId = 0) {
    const newRootFw = rootMtId == 0 ? targetId : rootMtId
    this.setState({
      value: names.join(" ") + " " + this.state.value,
      prevMtId: targetId, rootMtId: newRootFw
    })
    $("#contents").focus()
  }

  _flashForm() {
    const $formDiv = $("#new_firewood").parent()
    $formDiv.fadeOut(300).fadeIn(500)
  }

  _isbwTextEmpty() {
    return this.state.value.search(/^\s*$/) === 0
  }

  _isFormEmpty() {
    if ($("div.fileinput-exists").length === 0 && this._isbwTextEmpty()) {
      return true
    }
    return false
  }

  handleSubmit(event) {
    event.preventDefault()
    const $title = $("title")
    const $form = $("#new_firewood")

    if (this._isFormEmpty()) {
      app.channel.pulling(app.pageType, true)
    } else {
      const params = {
        data: {
          "firewood[contents]": this.state.value,
          "firewood[prev_mt_id]": this.state.prevMtId,
          "firewood[root_mt_id]": this.state.rootMtId,
          "adult_check": this.state.adultCheck
        }
      }
      const options = _.extend({}, app.channel.ajaxBasicOptions, params)
      $form.ajaxSubmit(options)
    }
    $title.html(this.props.originTitle)

    return false
  }

  handleTextChange(event) {
    const slicedValue = event.target.value.slice(0, this.state.maxCount)
    const newState = {value: slicedValue}
    if (slicedValue.length === 0) {
      newState.prevMtId = 0
      newState.rootMtId = 0
    }
    this.setState(newState)
    event.stopPropagation()
  }

  handleCheckboxChange(event) {
    const value = event.target.checked
    this.setState({adultCheck: value})
    event.stopPropagation()
  }

  handleChange(event) {
    this.setState({value: event.target.value})
    event.stopPropagation()
  }
}
