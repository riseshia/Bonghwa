import Agent from "./Agent"
import Store from "./Store"
import EventBus from "./EventBus"
import FirewoodsSerializer from "./FirewoodsSerializer"
import Dispatcher from "./Dispatcher"
import NativeComponent from "./components/NativeComponent"
import Channel from "./Channel"

const Actions = {
  authenticate(loginId, password) {
    return Agent.authenticate(loginId, password)
  },
  destroySession() {
    return Agent.destroySession()
  },

  changeType(type) {
    const global = Store.getState("global")
    global.type = type
    Store.setState("global", global, true)

    Dispatcher.request({
      method: "GET",
      path: "firewoods/now",
      params: { type },
      after: "afterChangeType",
      context: Actions
    })
  },
  afterChangeType(json) {
    Store.setState("firewoods", FirewoodsSerializer(json.fws, false))
  },

  setupForm(vm) {
    Agent.setupForm(vm.form)
  },
  saveForm(data) {
    Store.setState("form-state", data, true)
  },
  createFirewood(vm) {
    const formData = vm.formData()
    Dispatcher.request({
      params: { firewood: formData },
      after: "afterCreateFirewood",
      context: Actions,
      isForm: true
    })
    vm.clearForm()
    // formData.persisted = false
    // formData.name = Store.getState("user").user_name
    // formData.created_at = "--/--/-- --:--:--"
    // const pendedFws = FirewoodsSerializer([formData])
    // const currentFws = Store.getState("firewoods")
    // Store.setState("firewoods", pendedFws.concat(currentFws))
  },
  afterCreateFirewood() {
    const type = Store.getState("global").type
    const lastFwId = Store.getState("firewoods")[0].id
    Agent.getWithAuth(
      "firewoods/pulling",
      { after: lastFwId, type }
    ).then((json) => {
      const newFws = FirewoodsSerializer(json.fws)
      const fws = newFws.concat(Store.getState("firewoods")).filter((fw) => {
        fw.inStack = false
        return fw.persisted
      })
      Store.setState("firewoods", fws)
      Actions.updateStackCount()

      // Fetching for /nick
      if (json.user) { Store.setState("user", json.user) }
    })
  },
  destroyFirewood(vm) {
    vm.isDeleted = true
    Agent.deleteWithAuth(`firewoods/${vm.id}`).done(() => {
      const fws = Store.getState("firewoods").filter(fw => (fw.id !== vm.id))
      Store.setState("firewoods", fws)
    })
  },
  updateStackCount() {
    const count = Store.getState("firewoods").filter(fw => (fw.inStack)).length
    Store.setState("stackedCount", count)
  },
  flushStack() {
    const fws = Store.getState("firewoods").map((fw) => {
      fw.inStack = false
      return fw
    })
    Store.setState("firewoods", fws)
    Actions.updateStackCount()
  },
  toggleGlobalOption(key) {
    const global = Store.getState("global")
    global[key] = !global[key]
    Store.setState("global", global, true)

    if (key === "isImageAutoOpen") {
      this.toggleAllImage(global[key])
    }
  },
  toggleAllImage(newState) {
    EventBus.$emit("toggle-image-on-firewood", newState)
  },

  fetchApplication() {
    Dispatcher.request({
      method: "GET",
      path: "app",
      params: {},
      after: "afterFetchApplication",
      context: Actions
    })
  },
  afterFetchApplication(json) {
    Store.setState("app", json.app)
    Store.setState("user", json.user)
    Store.setState("users", json.users)
    Store.setState("informations", json.infos)
    Store.setState("firewoods", FirewoodsSerializer(json.fws, false))

    Channel.start()
    NativeComponent.start()
    Store.deliverAll()
  },

  fetchRecentFirewoods(options) {
    const lastFwId = Store.getState("firewoods")[0].id
    // if Last is undefined means app is fetching new one, so we could skip
    if (!lastFwId) { return }
    const type = Store.getState("global").type

    Dispatcher.request({
      method: "GET",
      params: { after: lastFwId, type },
      path: "firewoods/pulling",
      after: "afterFetchRecentFirewoods",
      context: Actions,
      options
    })
  },
  afterFetchRecentFirewoods(json, options = {}) {
    if (json.fws.length === 0) { return }
    const isNotLiveStreaming = !Store.getState("global").isLiveStreaming
    const newFws = FirewoodsSerializer(json.fws, isNotLiveStreaming)
    const currentFws = Store.getState("firewoods")
    Store.setState("firewoods", newFws.concat(currentFws))
    Actions.updateStackCount()

    if (options.afterFlush) {
      Actions.flushStack()
    }
  },

  fetchPrevFirewoods() {
    const fws = Store.getState("firewoods")
    if (fws.length < 50) { return }
    const type = Store.getState("global").type
    Dispatcher.request({
      method: "GET",
      path: "firewoods/trace",
      params: { before: fws[fws.length - 1].id, type, limit: 50 },
      after: "afterFetchPrevFirewoods",
      context: Actions
    })
  },
  afterFetchPrevFirewoods(json) {
    if (json.fws.length === 0) { return }
    const newFws = FirewoodsSerializer(json.fws, false)
    const recentFws = Store.getState("firewoods").concat(newFws)
    Store.setState("firewoods", recentFws)
  },

  fetchUsers() {
    Dispatcher.request({
      method: "GET",
      path: "users",
      after: "afterFetchUsers",
      context: Actions
    })
  },
  afterFetchUsers(json) {
    Store.setState("users", json.users)
  },

  fetchInformations() {
    Dispatcher.request({
      method: "GET",
      path: "infos",
      after: "afterFetchInformations",
      context: Actions
    })
  },
  afterFetchInformations(json) {
    if (json.infos.length === 0) { return }
    Store.setState("informations", json.infos)
  }
}

export default Actions
