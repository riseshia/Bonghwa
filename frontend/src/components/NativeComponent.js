import Vue from "vue"
import EventBus from "../EventBus"

export default new Vue({
  data() {
    return {
      app: {},
      firewoods: [],
      stackedCount: 0
    }
  },
  watch: {
    stackedCount(newVal) {
      if (newVal) {
        document.title = `(${newVal}) ${this.app.app_name}`
      } else {
        document.title = this.app.app_name
      }
    }
  },
  methods: {
    start() {
      const vm = this
      EventBus.$on("app", (obj) => { vm.app = obj })
      EventBus.$on("firewoods", (obj) => { vm.firewoods = obj })
      EventBus.$on("stackedCount", (count) => { vm.stackedCount = count })
    }
  }
})
