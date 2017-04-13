import Agent from "./Agent"
import Store from "./Store"
import FirewoodSerializer from "./FirewoodSerializer"

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
      Store.setState("firewoods", json.fws.map((fw) => {
        fw.inStack = false
        return FirewoodSerializer(fw)
      }))
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
      Store.setState("firewoods", json.fws.map((fw) => {
        fw.inStack = false
        return FirewoodSerializer(fw)
      }))
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
        const newFws = json.fws.map(fw => (FirewoodSerializer(fw)))
        const fws = newFws.concat(Store.getState("firewoods")).filter((fw) => {
          fw.inStack = false
          return fw.persisted
        })
        Store.setState("firewoods", fws)
      })
    })
    vm.clearForm()
    formData.persisted = false
    formData.name = Store.getState("user").user_name
    formData.created_at = "--/--/-- --:--:--"
    Store.prependElement("firewoods", FirewoodSerializer(formData))
  },
  destroyFirewood(vm) {
    vm.isDeleted = true
    Agent.deleteWithAuth(`firewoods/${vm.id}`).done(() => {
      const fws = Store.getState("firewoods").filter(fw => (fw.id !== vm.id))
      Store.setState("firewoods", fws)
    })
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
    const type = Store.getState("global").type
    Agent.getWithAuth(
      "firewoods/pulling",
      { after: lastFwId, type }
    ).then((json) => {
      if (json.fws.length === 0) { return }
      Store.prependElements("firewoods", json.fws.map(FirewoodSerializer))
    })
  }
}

export default Actions
