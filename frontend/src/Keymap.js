import Actions from "./Actions"

const keymaps = {
  2: 50,
  3: 51,
  4: 52
}

const addEvent = (obj, event, method) => {
  if (obj.addEventListener) {
    obj.addEventListener(event, method, false)
  } else if (obj.attachEvent) {
    obj.attachEvent(`on${event}`, () => { method(window.event) })
  }
}

const triggers = []
const addTrigger = (keyCode, callback) => {
  triggers.push({ key: keyCode, func: callback })
}

const inputTags = ["INPUT", "SELECT", "TEXTAREA"]
const isTriggeredInput = (event) => {
  const tagName = (event.target || event.srcElement).tagName
  return inputTags.indexOf(tagName) > -1
}

const startMonitoring = () => {
  addEvent(document, "keyup", (event) => {
    const pressedKey = event.keyCode || event.which || event.charCode

    if (isTriggeredInput(event)) { return }

    triggers
      .filter(({ key }) => (key === pressedKey))
      .forEach(({ func }) => {
        func(event)
      })
  })
}

export default {
  register() {
    startMonitoring()

    addTrigger(keymaps["2"], () => {
      Actions.toggleGlobalOption("isImageAutoOpen")
    })
    addTrigger(keymaps["3"], () => {
      Actions.toggleGlobalOption("isLiveStreaming")
    })
    addTrigger(keymaps["4"], () => {
      Actions.focusForm()
    })
  }
}
