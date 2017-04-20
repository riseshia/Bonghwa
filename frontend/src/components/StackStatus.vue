<template>
  <div class="row no-gutters stacked-count-area" v-if="stackedCount > 0" @click.prevent.stop="flushStack">
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
      Actions.flushStack({ needNotify: true })
    }
  }
}
</script>

<style scoped>
.stacked-count-area {
  padding: 0.5rem 1rem;
  text-align: center;
  text-decoration: underline;
  background-color: #e8f7ff; /* Blue-0 */
}
</style>
