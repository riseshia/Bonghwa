<template>
  <div class="row">
    <div class="col-sm-12">
      <firewood></firewood>
    </div>
  </div>
</template>

<script>
import Firewood from "./Firewood"

export default {
  name: "firewoods",
  components: {
    Firewood
  },
  props: ["firewoods"],
  computed: {
    stackCount() {
      return this.firewoods.filter(fw => !fw.isVisible).length
    },
    visibleFws() {
      return this.firewoods
    }
  },
  methods: {
    _flushStack() {
    }
  }
}
</script>

<style>
</style>

