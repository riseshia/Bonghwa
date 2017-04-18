import hotkeys from "hotkeys-js"
import Actions from "./Actions"

export default {
  register() {
    hotkeys("2", () => {
      Actions.toggleGlobalOption("isImageAutoOpen")
    })
    hotkeys("3", () => {
      Actions.toggleGlobalOption("isLiveStreaming")
    })
    hotkeys("4", () => {
      Actions.focusForm()
      return false
    })
  }
}
