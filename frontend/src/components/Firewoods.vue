<template>
  <div class="row no-gutters">
    <div class="col-sm-12">
      <firewood v-for="fw in firewoods" :key="fw.id"
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
                :isDeletable="fw.isDeletable"
                :isImageAutoOpen="isImageAutoOpen"
                :persisted="fw.persisted"
      ></firewood>
    </div>
  </div>
</template>

<script>
import Firewood from "./Firewood"

export default {
  name: "firewoods",
  components: {
    Firewood
  },
  props: ["firewoods", "isLiveStreaming", "isImageAutoOpen"]
}
</script>

<style>
</style>

