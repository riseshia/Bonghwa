class Channel {
  constructor() {
    this.pullingDictionary = {
      users: 5,
      pulling: 1,
      infos: 30
    }
  }

  start() {
    const keys = Object.keys(this.pullingDictionary)
    for (let i = 0; i !== keys.length; i += 1) {
      const key = keys[i]
      // this.register(key, this.pullingDictionary[key])
      console.log(`${key} is registered`)
    }
  }
  //
  // register(key, interval) {
  //   console.log(key + " is registered")
  // }
}
    // Agent.getWithAuth("app")
export default new Channel()
