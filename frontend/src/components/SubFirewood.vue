<template>
  <div class="row no-gutters">
    <div class="col">
      <div
        v-for="fw in firewoods"
        class="row">
        <div class="col-sm-auto">
          <div>{{ fw.name }}</div>
          <div>{{ fw.createdAt }}</div>
        </div>
        <div class="col">
          {{ fw.contents }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "sub-firewood",
  props: ["firewoods"]
}
</script>

<style>
</style>
