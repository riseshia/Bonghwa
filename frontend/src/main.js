// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue"
import VueRouter from "vue-router"
import Store from "./Store"
import Router from "./Router"
import Keymap from "./Keymap"

// Start Bootstrap & jQuery
window.$ = require("jquery")

window.jQuery = window.$
require("../vendor/jquery.form")
require("../vendor/jquery.customFile")

window.Tether = require("tether")

require("bootstrap")
// End Bootstrap & jQuery

Vue.use(VueRouter)

Store.fetchState("global", {
  type: 1,
  isImageAutoOpen: false,
  isLiveStreaming: false,
  cachingForm: false
})
Keymap.register()

new Vue({ router: Router }).$mount("#app")
