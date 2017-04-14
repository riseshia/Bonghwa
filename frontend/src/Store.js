import EventBus from "./EventBus"
import CacheStorage from "./CacheStorage"

class Store {
  constructor() {
    this.state = {}
  }

  setState(key, value, caching = false) {
    this.state[key] = value
    if (caching) {
      CacheStorage.set(key, value)
    }
    this.emit(key)
  }

  getState(key) {
    return this.state[key]
  }

  fetchState(key, defaultValue) {
    const cached = CacheStorage.get(key)
    if (cached) {
      this.setState(key, cached)
    } else {
      this.setState(key, defaultValue, true)
    }
  }

  deliverAll() {
    this.emit("global")
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
