import OnScreen from "onscreen"
import Actions from "./Actions"

const os = new OnScreen({
  tolerance: 0,
  debounce: 2000
})

const registerTimer = (fn, delay) => {
  setInterval(fn, delay)
}

const Channel = {
  start() {
    registerTimer(Actions.fetchUsers, 5000)
    registerTimer(Actions.fetchInformations, 30000)
    registerTimer(Actions.fetchFirewoods, 1000)
    os.on("enter", ".firewood:nth-last-child(10)", () => {
      Actions.fetchScroll()
    })
  }
}

export default Channel
