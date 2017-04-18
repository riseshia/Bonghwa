// import DispatchObserver from "./DispatchObserver"
import Agent from "./Agent"

const Dispatcher = {
  queue: [],
  isIng: false,

  request(options) {
    this.queue.push(options)

    if (this.queue.length === 1) {
      window.setTimeout(this.fetch.bind(this), 1)
    }
  },

  fetch() {
    if (this.queue.length === 0 || this.isIng) { return }
    this.isIng = true

    const {
      method, path, params, after, requested, context, isForm, options
    } = this.queue.shift()
    const thenCb = (json) => {
      context[after](json, options)
      this.isIng = false
      window.setTimeout(this.fetch.bind(this), 1)
    }
    if (isForm) {
      Agent.submitForm(params, thenCb)
    } else {
      Agent.requestWithAuth(method, path, params).then(thenCb)
    }
    if (requested) {
      context[requested]()
    }
  }
}

export default Dispatcher
