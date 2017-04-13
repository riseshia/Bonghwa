import Actions from "./Actions"

const registerTimer = (fn, delay) => {
  setInterval(fn, delay)
}

const Channel = {
  start() {
    registerTimer(Actions.fetchUsers, 5000)
    registerTimer(Actions.fetchInformations, 30000)
    registerTimer(Actions.fetchFirewoods, 1000)
  }
}

export default Channel
