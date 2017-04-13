<template>
  <div class="row">
    <div class="col-sm-12">
      <firewood v-for="fw in visibleFws" :key="fw.id"
                :id="fw.id"
                :contents="fw.contents"
                :createdAt="fw.createdAt"
                :imageAdultFlg="fw.imageAdultFlg"
                :imageUrl="fw.imageUrl"
                :isDm="fw.isDm"
                :name="fw.name"
                :mentionedNames="fw.mentionedNames"
                :prevMtId="fw.prevMtId"
                :rootMtId="fw.rootMtId"
                :userId="fw.userId"
                :isImgOpened="fw.isImgOpened"
                :isDeletable="fw.isDeletable"
                :isTextOpened="fw.isTextOpened"
                :persisted="fw.persisted"
      ></firewood>
    </div>
  </div>
</template>

<script>
import Firewood from "./Firewood"
import EventBus from "../EventBus"

export default {
  name: "firewoods",
  components: {
    Firewood
  },
  beforeCreate() {
    const vm = this
    EventBus.$on("firewoods", (firewoods) => {
      vm.firewoods = firewoods
    })
  },
  props: ["isLiveStreaming", "isImageAutoOpen"],
  data() {
    return {
      firewoods: [],
      defaultIsImgOpened: false
    }
  },
  computed: {
    visibleFws() {
      return this.firewoods.filter(fw => (!fw.inStack))
    }
  },
  methods: {
    _flushStack() {
    }
  }
}
</script>

<style>
</style>

