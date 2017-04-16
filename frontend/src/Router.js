import VueRouter from "vue-router"
import App from "./App"
import SignIn from "./SignIn"
import Agent from "./Agent"

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

export default new VueRouter({ routes })
