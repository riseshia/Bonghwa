// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue"
import VueRouter from "vue-router"
import App from "./App"
import SignIn from "./SignIn"
import Agent from "./Agent"

// Start Bootstrap & jQuery
window.$ = require("jquery")

window.jQuery = window.$
require("../vendor/jquery.form")
require("../vendor/jquery.customFile")

window.Tether = require("tether")

require("bootstrap")
// End Bootstrap & jQuery

Vue.use(VueRouter)

const routes = [
  {
    path: "/",
    component: App,
    beforeEnter: (to, from, next) => {
      if (Agent.isLogined()) {
        next()
      } else {
        next("/sign_in")
      }
    }
  },
  {
    path: "/sign_in",
    component: SignIn,
    beforeEnter: (to, from, next) => {
      if (Agent.isLogined()) {
        next("/")
      } else {
        next()
      }
    }
  },
  { path: "*", redirect: "/sign_in" }
]
const router = new VueRouter({ routes })

new Vue({ router }).$mount("#app")
