<template>
  <div class="row no-gutters">
    <div class="col-sm-12">
      <firewood v-for="fw in timeline" :key="fw.id"
                :id="fw.id"
                :contents="fw.contents"
                :createdAt="fw.createdAt"
                :imageAdultFlg="fw.imageAdultFlg"
                :imageUrl="fw.imageUrl"
                :isDm="fw.isDm"
                :name="fw.name"
                :mentionedNames="fw.mentionedNames"
                :parents="fw.parents"
                :prevMtId="fw.prevMtId"
                :rootMtId="fw.rootMtId"
                :userId="fw.userId"
                :status="fw.status"
                :isLastRecent="fw.isLastRecent"
                :isDeletable="fw.isDeletable"
                :parentNotEnough="fw.parentNotEnough"
                :isMentioned="fw.isMentioned"
                :isImageAutoOpen="isImageAutoOpen"
      ></firewood>
    </div>
  </div>
</template>

<script>
import FirewoodFn from "../FirewoodFn"

import Firewood from "./Firewood"

export default {
  name: "firewoods",
  components: {
    Firewood
  },
  props: ["firewoods", "isLiveStreaming", "isImageAutoOpen"],
  computed: {
    timeline() {
      return this.firewoods.filter(fw => FirewoodFn.inTimeline(fw))
    }
  }
}
</script>

<style>
</style>
