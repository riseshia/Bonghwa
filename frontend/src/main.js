// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue"
import App from "./App"
import Channel from "./Channel"
import Actions from "./Actions"
import NativeComponent from "./components/NativeComponent"

// Start Bootstrap & jQuery
window.$ = require("jquery")

window.jQuery = window.$

require("../vendor/jquery.form")

window.Tether = require("tether")

require("bootstrap")
// End Bootstrap & jQuery

Actions.authenticate(loginId, password).then(() => {
  Actions.loadApplication().then(() => {
    Channel.start()

    /* eslint-disable no-new */
    new Vue({
      el: "#app",
      template: "<App/>",
      components: { App }
    })
    NativeComponent.start()
    Actions.refreashApplication()
  })
})
