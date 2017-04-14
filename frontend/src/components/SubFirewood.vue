<template>
  <div class="row no-gutters fw-parents">
    <div class="col">
      <div
        v-for="fw in parsedFirewoods"
        :key="fw.id"
        class="row no-gutters">
        <div class="col-sm-auto meta-info">
          {{ fw.createdAt }} -
          {{ fw.name }}
        </div>
        <div class="col message">
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
          name: fw.name,
          contents: autolink(fw.contents, { classes }),
          imageAdultFlg: fw.imageAdultFlg,
          imageUrl: fw.imageUrl,
          createdAt: fw.createdAt.split(" ")[1]
        }
      })
    }
  }
}
</script>

<style scoped>
.fw-parents {
  font-size: 90%;
}
.message::before {
  content: ":";
  padding-left: 3px;
  padding-right: 3px;
}
.message {
}
</style>
