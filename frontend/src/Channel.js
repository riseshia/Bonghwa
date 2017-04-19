import OnScreen from "onscreen"
import Actions from "./Actions"
import EventBus from "./EventBus"

const os = new OnScreen({
  tolerance: 0,
  debounce: 2000
})

const lockingConcurrency = {}
const setTimer = (key, fn, delay) => {
  if (lockingConcurrency[key]) { return }
  lockingConcurrency[key] = true
  setTimeout(() => {
    fn()
    lockingConcurrency[key] = false
  }, delay)
}

const fetchPrevFirewoodsCb = () => {
  Actions.fetchPrevFirewoods()
}

const Channel = {
  timerId: [],

  start() {
    os.on("enter", ".firewood:nth-last-child(10)", fetchPrevFirewoodsCb)
    EventBus.$on("fetch-users-success", () => {
      setTimer("users", Actions.fetchUsers, 5000)
    })
    EventBus.$on("fetch-informations-success", () => {
      setTimer("informations", Actions.fetchInformations, 30000)
    })
    EventBus.$on("fetch-firewoods-success", () => {
      setTimer("firewoods", Actions.fetchRecentFirewoods, 1000)
    })
    EventBus.$emit("fetch-users-success")
    EventBus.$emit("fetch-informations-success")
    EventBus.$emit("fetch-firewoods-success")
  },

  stop() {
    os.off("enter", ".firewood:nth-last-child(10)", fetchPrevFirewoodsCb)
    EventBus.$off("fetch-users-success")
    EventBus.$off("fetch-informations-success")
    EventBus.$off("fetch-firewoods-success")
  }
}

export default Channel
