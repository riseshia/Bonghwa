import EventBus from "./EventBus"

class Store {
  constructor() {
    this.state = {
      user: { name: "User" }
    }
  }

  setState(key, value) {
    this.state[key] = value
    this.emit(key)
  }

  getState(key) {
    return this.state[key]
  }

  prependElement(key, value) {
    this.state[key].unshift(value)
    this.emit(key)
  }

  deliverAll() {
    this.emit("firewoods")
    this.emit("users")
    this.emit("informations")
  }

  emit(key) {
    EventBus.$emit(key, this.state[key])
  }
}
export default new Store()
