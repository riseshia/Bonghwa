// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue"
import App from "./App"
import Channel from "./Channel"
import Agent from "./Agent"
import Store from "./Store"
import FirewoodSerializer from "./FirewoodSerializer"

// Start Bootstrap & jQuery
window.$ = require("jquery")

window.jQuery = window.$

require("../vendor/jquery.form")

window.Tether = require("tether")

require("bootstrap")
// End Bootstrap & jQuery

Agent.authenticate(loginId, password).then(() => {
  Agent.getWithAuth("app").then((json) => {
    Store.setState("global", {
      type: 1,
      isImageAutoOpen: false,
      isLiveStreaming: false
    })
    Store.setState("user", json.user)
    Store.setState("firewoods", json.fws.map((fw) => {
      fw.inStack = false
      return FirewoodSerializer(fw)
    }))
    Store.setState("informations", json.infos)
    Store.setState("users", json.users)
    Store.setState("app", json.app)

    Channel.start()

    /* eslint-disable no-new */
    new Vue({
      el: "#app",
      template: "<App/>",
      components: { App }
    })
    Store.deliverAll()
  })
})
