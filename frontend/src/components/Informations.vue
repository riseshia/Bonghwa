<template>
  <div
    v-if="isVisible && informations.length > 0"
    class="row no-gutters informations"
  >
    <div class="col-sm-12">
      <div class="alert alert-info alert-dismissible fade show" role="alert">
        <button type="button" class="close"
                data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>

        <h5>공지사항</h5>
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
      return this.informations.map((info, idx) => (
        {
          id: info.id,
          information: `${idx + 1}. ${autolink(info.information)}`
        }
      ))
    }
  }
}
</script>

<style scoped>
/* Mobile */
.informations {
  margin-top: 125px;
}

/* PC */
@media (min-width: 576px) {
  .informations {
    margin-top: 104px;
  }
}

.alert {
  border-radius: 0;
  border: 0px solid transparent;
  margin-bottom: 0;
}
</style>

