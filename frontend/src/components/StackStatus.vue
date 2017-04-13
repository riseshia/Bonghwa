<template>
  <div class="row" v-if="countInStack > 0" @click.prevent.stop="flushStack">
    <div class="col-sm-12">
      아직 읽지 않은 장작이 {{ countInStack }}개 있습니다.
    </div>
  </div>
</template>

<script>
import EventBus from "../EventBus"
import Store from "../Store"

export default {
  name: "stack-status",
  beforeCreate() {
    const vm = this
    EventBus.$on("firewoods", (firewoods) => {
      vm.firewoods = firewoods
    })
  },
  data() {
    return { firewoods: [] }
  },
  computed: {
    countInStack() {
      return this.firewoods.filter(fw => (fw.inStack)).length
    }
  },
  methods: {
    flushStack() {
      const fws = this.firewoods.map((fw) => {
        fw.inStack = false
        return fw
      })
      Store.setState("firewoods", fws)
    }
  }
}
</script>

<style>
</style>
