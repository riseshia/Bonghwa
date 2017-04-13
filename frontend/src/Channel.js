import Agent from "./Agent"
import Store from "./Store"
import FirewoodSerializer from "./FirewoodSerializer"

const fetchInformations = () => {
  Agent.getWithAuth("infos").then((json) => {
    if (json.infos.length === 0) { return }
    Store.setState("informations", json.infos)
  })
}

const fetchUsers = () => {
  Agent.getWithAuth("users").then((json) => {
    Store.setState("users", json.users)
  })
}

const fetchFirewoods = () => {
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

const registerTimer = (fn, delay) => {
  setInterval(fn, delay)
}

const Channel = {
  start() {
    registerTimer(fetchUsers, 5000)
    registerTimer(fetchInformations, 30000)
    registerTimer(fetchFirewoods, 1000)
  }
}

export default Channel
