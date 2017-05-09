import Agent from "./Agent"
import Store from "./Store"
import EventBus from "./EventBus"
import FirewoodFn from "./FirewoodFn"
import TimelineTypeFn from "./TimelineTypeFn"
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
    Store.setState("firewoods", FirewoodFn.initializeInTL(json.fws))
  },

  setupForm(vm) {
    Agent.setupForm(vm.form)
  },
  saveForm(data) {
    Store.setState("form-state", data, true)
  },
  destroyFirewood(vm) {
    Agent.deleteWithAuth(`firewoods/${vm.id}`).done(() => {
      const fws = Store.getState("firewoods").filter(fw => (fw.id !== vm.id))
      Store.setState("firewoods", fws)
    })
  },
  updateStackCount() {
    const count = Store.getState("firewoods").filter(fw => (FirewoodFn.inStack(fw))).length
    Store.setState("stackedCount", count)
  },
  flushStack(options = {}) {
    const fws = FirewoodFn.flushAll(Store.getState("firewoods"), options)
    Store.setState("firewoods", fws)
    Actions.updateStackCount()
  },
  toggleGlobalOption(key) {
    const global = Store.getState("global")
    global[key] = !global[key]
    Store.setState("global", global, true)
    EventBus.$emit("notify", { key, value: global[key] })

    if (key === "isImageAutoOpen") {
      this.toggleAllImage(global[key])
    }
  },
  toggleAllImage(newState) {
    EventBus.$emit("toggle-image-on-firewood", newState)
  },
  focusForm() {
    EventBus.$emit("focus")
  },
  focusFirewood(newId, oldId) {
    const fws = Store.getState("firewoods")
    if (oldId) {
      FirewoodFn.findbyId(fws, oldId).isMentioned = false
    }
    if (newId) {
      FirewoodFn.findbyId(fws, newId).isMentioned = true
    }
    Store.setState("firewoods", fws)
  },

  fetchApplication() {
    const type = Store.getState("global").type
    Dispatcher.request({
      method: "GET",
      path: "app",
      params: { type },
      after: "afterFetchApplication",
      context: Actions
    })
  },
  afterFetchApplication(json) {
    Store.setState("app", json.app)
    Store.setState("user", json.user)
    Store.setState("users", json.users)
    Store.setState("informations", json.infos)
    Store.setState("firewoods", FirewoodFn.initializeInTL(json.fws))

    Channel.start()
    NativeComponent.start()
    Store.deliverAll()
  },
  stopApplication() {
    Channel.stop()
  },

  forceFetchRecentFirewoods() {
    EventBus.$emit("notify", { message: "최신 장작을 받아오고 있습니다." })
    this.fetchRecentFirewoods({ notUsingStack: true })
  },
  fetchRecentFirewoods(options = {}) {
    const type = Store.getState("global").type
    const passingParams = { type }

    const lastFw = FirewoodFn.lastPersisted(Store.getState("firewoods"))
    if (lastFw) {
      passingParams.after = lastFw.id
      options.lastFwId = lastFw.id
    }

    Dispatcher.request({
      method: "GET",
      params: passingParams,
      path: "firewoods/pulling",
      after: "afterFetchRecentFirewoods",
      context: Actions,
      options
    })
  },
  afterFetchRecentFirewoods(json, options = {}) {
    if (json.fws.length !== 0) {
      const currentFws =
        FirewoodFn.removePending(Store.getState("firewoods"), options)

      if (json.fws[0].id > currentFws[0].id) {
        const isNotLiveStreaming = !Store.getState("global").isLiveStreaming
        const newFws = FirewoodFn.initialize(json.fws, isNotLiveStreaming)
        Store.setState("firewoods", newFws.concat(currentFws))
        Actions.updateStackCount()

        // Fetching for /nick
        if (json.user) { Store.setState("user", json.user) }
      }
    }

    if (options.notUsingStack) {
      Actions.flushStack()
    }
    EventBus.$emit("fetch-firewoods-success")
  },

  createFirewood(vm) {
    const formData = vm.formData()
    formData.ts = +(new Date())
    Dispatcher.request({
      params: { firewood: formData },
      after: "afterCreateFirewood",
      requested: "requestedCreateFirewood",
      context: Actions,
      isForm: true,
      options: {
        notUsingStack: true,
        ts: formData.ts
      }
    })

    const currentType = TimelineTypeFn.find(
      Store.getState("global").type
    )
    if (currentType.needDummy) {
      const user = Store.getState("user")
      const pendedFws = FirewoodFn.initializeDummy(formData, user)
      const currentFws = Store.getState("firewoods")
      Store.setState("firewoods", pendedFws.concat(currentFws))
    }
  },
  afterCreateFirewood(_, options) {
    Actions.fetchRecentFirewoods(options)
  },
  requestedCreateFirewood() {
    EventBus.$emit("requested-form")
  },

  fetchParents(fwId, rootMtId) {
    const fws = Store.getState("firewoods")
    const fw = FirewoodFn.findbyId(fws, fwId)
    Dispatcher.request({
      method: "GET",
      path: `firewoods/${rootMtId}/mentions`,
      params: { target_id: fwId },
      after: "afterFetchParents",
      context: Actions,
      options: { targetFw: fw }
    })
  },
  afterFetchParents(json, { targetFw }) {
    if (json.fws.length === 0) { return }
    targetFw.parents = FirewoodFn.initializeInTL(json.fws)
    const fws = Store.getState("firewoods")
    Store.setState("firewoods", fws)
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
    const newFws = FirewoodFn.initializeInTL(json.fws)
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
    EventBus.$emit("fetch-users-success")
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
    EventBus.$emit("fetch-informations-success")
  },

  createFavorite(fwId) {
    Dispatcher.request({
      method: "POST",
      path: "favorites",
      params: { firewood_id: fwId },
      after: "afterCreateFavorite",
      context: Actions,
      options: { targetFwId: fwId }
    })
  },
  afterCreateFavorite({ status }, { targetFwId }) {
    if (status === "success") {
      const fws = Store.getState("firewoods")
      const fw = FirewoodFn.findbyId(fws, targetFwId)
      fw.isFaved = true

      Store.setState("firewoods", fws)
    }
  },

  destroyFavorite(fwId) {
    Dispatcher.request({
      method: "DELETE",
      path: "favorites",
      params: { firewood_id: fwId },
      after: "afterDestroyFavorite",
      context: Actions,
      options: { targetFwId: fwId }
    })
  },
  afterDestroyFavorite({ status }, { targetFwId }) {
    if (status === "success") {
      const fws = Store.getState("firewoods")
      const fw = FirewoodFn.findbyId(fws, targetFwId)
      fw.isFaved = false

      Store.setState("firewoods", fws)
    }
  }
}

export default Actions
