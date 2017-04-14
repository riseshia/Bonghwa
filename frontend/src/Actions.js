import Agent from "./Agent"
import Store from "./Store"
import FirewoodsSerializer from "./FirewoodsSerializer"

const Actions = {
  authenticate(loginId, password) {
    return Agent.authenticate(loginId, password)
  },
  refreashApplication() {
    Store.deliverAll()
  },
  loadApplication() {
    return Agent.getWithAuth("app").then((json) => {
      Store.setState("global", {
        type: 1,
        isImageAutoOpen: false,
        isLiveStreaming: false
      })
      Store.setState("user", json.user)
      Store.setState("firewoods", FirewoodsSerializer(json.fws, false))
      Store.setState("informations", json.infos)
      Store.setState("users", json.users)
      Store.setState("app", json.app)
    })
  },
  changeType(type) {
    const global = Store.getState("global")
    global.type = type
    Store.setState("global", global)
    Agent.getWithAuth("firewoods/now", { type }).then((json) => {
      Store.setState("firewoods", FirewoodsSerializer(json.fws, false))
    })
  },
  setupForm(vm) {
    Agent.setupForm(vm.form)
  },
  createFirewood(vm) {
    const formData = vm.formData()
    const lastFwId = Store.getState("firewoods")[0].id
    Agent.submitForm({ firewood: formData }, () => {
      const type = Store.getState("global").type
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
      })
    })
    vm.clearForm()
    formData.persisted = false
    formData.name = Store.getState("user").user_name
    formData.created_at = "--/--/-- --:--:--"
    const pendedFws = FirewoodsSerializer([formData])
    const currentFws = Store.getState("firewoods")
    Store.setState("firewoods", pendedFws.concat(currentFws))
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
  fetchInformations() {
    Agent.getWithAuth("infos").then((json) => {
      if (json.infos.length === 0) { return }
      Store.setState("informations", json.infos)
    })
  },
  fetchUsers() {
    Agent.getWithAuth("users").then((json) => {
      Store.setState("users", json.users)
    })
  },
  fetchFirewoods() {
    const lastFwId = Store.getState("firewoods")[0].id
    // if Last is undefined means app is fetching new one, so we could skip
    if (!lastFwId) { return window.$.when(null) }
    const type = Store.getState("global").type

    return Agent.getWithAuth(
      "firewoods/pulling",
      { after: lastFwId, type }
    ).then((json) => {
      if (json.fws.length === 0) { return }
      const isNotLiveStreaming = !Store.getState("global").isLiveStreaming
      const newFws = FirewoodsSerializer(json.fws, isNotLiveStreaming)
      const currentFws = Store.getState("firewoods")
      Store.setState("firewoods", newFws.concat(currentFws))
      Actions.updateStackCount()
    })
  },
  fetchScroll() {
    const fws = Store.getState("firewoods")
    if (fws.length < 50) {
      return false
    }

    const type = Store.getState("global").type
    return Agent.getWithAuth(
      "firewoods/trace",
      { before: fws[fws.length - 1].id, type, limit: 50 }
    ).then((json) => {
      if (json.fws.length === 0) { return }
      const newFws = FirewoodsSerializer(json.fws, false)
      const recentFws = Store.getState("firewoods").concat(newFws)
      Store.setState("firewoods", recentFws)
    })
  },
  toggleGlobalOption(key) {
    const global = Store.getState("global")
    global[key] = !global[key]
    Store.setState("global", global)
  }
}

export default Actions
