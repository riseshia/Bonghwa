// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue"
import Vuex from "vuex"
import App from "./App"

// Start Bootstrap & jQuery
window.$ = require("jquery")

window.jQuery = window.$

window.Tether = require("tether")

require("bootstrap")
// End Bootstrap & jQuery

Vue.config.productionTip = false
Vue.use(Vuex)

/* eslint-disable no-new */
new Vue({
  el: "#app",
  template: "<App/>",
  components: { App }
})
