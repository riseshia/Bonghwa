<template>
  <div class="row" v-if="stackedCount > 0" @click.prevent.stop="flushStack">
    <div class="col-sm-12">
      아직 읽지 않은 장작이 {{ stackedCount }}개 있습니다.
    </div>
  </div>
</template>

<script>
import Actions from "../Actions"

export default {
  name: "stack-status",
  props: ["stackedCount"],
  methods: {
    flushStack() {
      Actions.flushStack()
    }
  }
}
</script>

<style>
</style>
