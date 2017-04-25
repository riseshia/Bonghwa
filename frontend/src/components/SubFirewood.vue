<template>
  <div class="row no-gutters fw-parents">
    <div class="col">
      <div
        v-for="fw in parsedFirewoods"
        :key="fw.id"
        class="row no-gutters">
        <div class="col-sm-auto name-area">
          {{ fw.name }}
        </div>
        <div class="col message">
          <span v-html="fw.contents"></span>

          <span
            v-if="fw.imageUrl"
            :class="{ 'link-url-danger': fw.sensitiveFlg, 'link-url': !fw.sensitiveFlg }">{{ fw.imageName }}</span>
        </div>
        <div class="col-sm-auto hidden-xs-down">
          {{ fw.createdAt }}
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
        if (fw.sensitiveFlg) { classes.push("link-url-danger") }

        return {
          id: fw.id,
          name: fw.name,
          contents: autolink(fw.contents, { classes }),
          sensitiveFlg: fw.sensitiveFlg,
          imageName: `[이미지 ${fw.id}]`,
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
.name-area::after {
  content: ":";
  padding-left: 2px;
  padding-right: 2px;
}
</style>
