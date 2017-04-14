<template>
  <div class="row no-gutters">
    <div class="col">
      <div
        v-for="fw in parsedFirewoods"
        :key="fw.id"
        class="row no-gutters">
        <div class="col-sm-auto">
          <div>{{ fw.name }}</div>
          <div>{{ fw.createdAt }}</div>
        </div>
        <div class="col">
          <span v-html="fw.contents"></span>
          <span
            v-if="fw.imageUrl"
            :class="{ 'text-danger': fw.imageAdultFlg }">[이미지]</span>
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
      return this.firewoods.map((fw) => {
        const classes = []
        if (fw.imageAdultFlg) { classes.push("text-danger") }

        return {
          id: fw.id,
          contents: autolink(fw.contents, { classes }),
          imageAdultFlg: fw.imageAdultFlg,
          imageUrl: fw.imageUrl,
          createdAt: fw.createdAt
        }
      })
    }
  }
}
</script>

<style>
</style>
