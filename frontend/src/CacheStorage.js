const localStorage = window.localStorage

const CacheStorage = {
  set(key, value) {
    localStorage[key] = JSON.stringify(value)
  },
  delete(key) {
    this.set(key, null)
  },
  get(key) {
    if (!localStorage[key]) { return null }
    return JSON.parse(localStorage[key])
  }
}

export default CacheStorage
