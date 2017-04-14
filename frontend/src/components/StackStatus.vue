<template>
  <div class="row no-gutters alert alert-warning" v-if="stackedCount > 0" @click.prevent.stop="flushStack">
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

<style scoped>
.alert {
  border-radius: 0;
  border: 0px solid transparent;
  margin-bottom: 0;
  padding: 0.5rem 1rem;
  text-align: center;
  text-decoration: underline;
}
</style>
