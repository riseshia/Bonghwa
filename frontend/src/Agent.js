import CacheStorage from "./CacheStorage"
import Router from "./Router"

class Agent {
  constructor() {
    const cache = CacheStorage.get("auth")
    if (cache) {
      this.identifier = cache.identifier
      this.token = cache.token
    } else {
      this.identifier = null
      this.token = null
    }
    this.$form = null
    this.apiHost = `${process.env.API_HOST}/aapi`
  }

  isLogined() {
    return this.token !== null
  }

  clearSession() {
    this.identifier = null
    this.token = null
    CacheStorage.delete("auth")
  }

  authenticate(id, password) {
    const identifier = id
    return window.$.ajax({
      url: `${this.apiHost}/session`,
      type: "POST",
      dataType: "json",
      data: {
        login_id: identifier,
        password
      }
    }).then((json) => {
      if (json.status === "success") {
        this.identifier = identifier
        this.token = json.token

        CacheStorage.set("auth", {
          identifier: this.identifier, token: this.token
        })
      }
      return this.isLogined()
    })
  }

  destroySession() {
    const self = this
    return self.deleteWithAuth("session").then(() => {
      self.identifier = null
      self.token = null
      CacheStorage.delete("auth")
    })
  }

  getWithAuth(path, params = {}) {
    return this.requestWithAuth("GET", path, params)
  }

  deleteWithAuth(path, params = {}) {
    return this.requestWithAuth("DELETE", path, params)
  }

  requestWithAuth(httpType, path, params = {}) {
    const self = this

    return window.$.ajax({
      url: `${this.apiHost}/${path}`,
      type: httpType,
      headers: this.authHeaders(),
      dataType: "json",
      data: params
    }).fail((res, status) => {
      // Auth Error, so delete token
      if (status === "parsererror") {
        self.clearSession()
        Router.push("/sign_in")
      }
    })
  }

  authHeaders() {
    return {
      "X-User-Identifier": this.identifier,
      "X-User-Token": this.token
    }
  }

  setupForm($el) {
    this.$form = $el
    $el.ajaxForm()
  }

  submitForm(formData, successCb) {
    this.$form.ajaxSubmit({
      url: `${this.apiHost}/firewoods`,
      type: "POST",
      headers: this.authHeaders(),
      dataType: "json",
      data: formData,
      success: successCb
    })
  }
}

export default new Agent()
