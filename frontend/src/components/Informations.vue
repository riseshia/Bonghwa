<template>
  <div class="row" v-if="isVisible && informations.length > 0">
    <div class="col-sm-12">
      <div class="alert alert-info alert-dismissible fade show" role="alert">
        <button type="button" class="close"
                data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>

        <p
          v-for="info in parsedInfomations" :key="info.id"
          v-html="info.information"
          style="margin-bottom: 0;">
        </p>
      </div>
    </div>
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
      return this.informations.map(info => (
        { id: info.id, information: autolink(info.information) }
      ))
    }
  }
}
</script>

<style>
</style>

