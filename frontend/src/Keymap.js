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

export default {
  register() {
    addEvent(document, "keyup", (event) => {
      const pressedKey = event.keyCode || event.which || event.charCode

      triggers
        .filter(({ key }) => (key === pressedKey))
        .forEach(({ func }) => {
          func(event)
        })
    })

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
