<template>
  <div class="row" v-if="infosVisible && infos.length > 0">
    <div class="col-sm-12">
      <div class="alert alert-info alert-dismissible fade show" role="alert">
        <button type="button" class="close"
                data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>

        <strong>Heads up!</strong>
        This alert needs your attention, but it's not super important.
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "informations",
  props: ["infos", "infosVisible"]
}
</script>

<style>
</style>

