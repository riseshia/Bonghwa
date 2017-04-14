<template>
  <div class="row no-gutters">
    <div class="col">
      <div
        v-for="fw in parsedFirewoods"
        :key="fw.id"
        class="row">
        <div class="col-sm-auto">
          <div>{{ fw.name }}</div>
          <div>{{ fw.createdAt }}</div>
        </div>
        <div class="col">
          <span v-html="fw.contents"></span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import autolink from "../utils/autolink"

export default {
  name: "sub-firewood",
  props: ["firewoods"],
  computed: {
    parsedFirewoods() {
      return this.firewoods.map(fw => (
        {
          id: fw.id,
          contents: autolink(fw.contents),
          createdAt: fw.createdAt
        }
      ))
    }
  }
}
</script>

<style>
</style>
