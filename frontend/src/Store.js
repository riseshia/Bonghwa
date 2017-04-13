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

  prependElement(key, value) {
    this.state[key].unshift(value)
    this.emit(key)
  }

  prependElements(key, values) {
    this.state[key] = values.concat(this.state[key])
    this.emit(key)
  }

  deliverAll() {
    this.emit("users")
    this.emit("user")
    this.emit("app")
    this.emit("informations")
    this.emit("firewoods")
  }

  emit(key) {
    EventBus.$emit(key, this.state[key])
  }
}
export default new Store()
