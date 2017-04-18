<template>
  <transition name="sliding">
    <div v-if="isVisible" class="row no-gutters notifier">
      <div class="col-sm-12">
        <div class="text-center" role="alert">
          {{ message }}
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import EventBus from "../EventBus"

const transTable = {
  isImageAutoOpen: "이미지 자동 열기가 ",
  isLiveStreaming: "라이브 스트리밍이 ",
  cachingForm: "임시 저장 기능이 "
}

export default {
  name: "notifier",
  beforeCreate() {
    const vm = this
    EventBus.$on("notify", (options) => {
      vm.message = vm.buildMessage(options)
      vm.isVisible = true

      if (vm.timerId) {
        clearTimeout(vm.timerId)
      }
      vm.timerId = setTimeout(() => {
        vm.dismissSelf()
      }, 2000)
    })
  },
  data() {
    return {
      isVisible: false,
      message: "",
      timerId: null
    }
  },
  methods: {
    buildMessage({ message, key, value }) {
      if (message) { return message }

      let builtMessage = transTable[key]
      if (value) {
        builtMessage += "활성화되었습니다."
      } else {
        builtMessage += "비활성화되었습니다."
      }

      return builtMessage
    },
    dismissSelf() {
      this.isVisible = false
    }
  }
}
</script>

<style scoped>
.notifier {
  background-color: #a3daff; /* Blue-3 */
  padding: 10px;
}
</style>
