<template>
  <div
    v-if="informations.length > 0"
    class="row no-gutters informations"
  >
    <transition name="sliding">
      <div
        v-if="isVisible" @click="dismissSelf"
        class="col-sm-12"
      >
        <div class="alert alert-info" role="alert">
          <h5>공지사항</h5>
          <p
            v-for="info in parsedInfomations" :key="info.id"
            v-html="info.information"
            style="margin-bottom: 0;">
          </p>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import EventBus from "../EventBus"
import autolink from "../utils/autolink"

export default {
  name: "informations",
  beforeCreate() {
    const vm = this
    EventBus.$on("informations", (informations) => {
      vm.informations = informations
      vm.isVisible = true
    })
  },
  data() {
    return {
      isVisible: true,
      informations: []
    }
  },
  computed: {
    parsedInfomations() {
      return this.informations.map((info, idx) => (
        {
          id: info.id,
          information: `${idx + 1}. ${autolink(info.information)}`
        }
      ))
    }
  },
  methods: {
    dismissSelf() {
      console.log(1)
      this.isVisible = false
    }
  }
}
</script>

<style scoped>
.alert {
  border-radius: 0;
  border: 0px solid transparent;
  margin-bottom: 0;
}
</style>
