import EventBus from "./EventBus"

class Store {
  constructor() {
    this.state = {}
  }

  setState(key, value) {
    this.state[key] = value
    this.emit(key)
  }

  getState(key) {
    return this.state[key]
  }

  deliverAll() {
    this.emit("users")
    this.emit("user")
    this.emit("app")
    this.emit("informations")
    this.emit("firewoods")
    this.emit("stackedCount")
  }

  emit(key) {
    EventBus.$emit(key, this.state[key])
  }
}
export default new Store()
