<template>
  <div :class="{ row: true, 'text-muted': !persisted || isDm }">
    <div class="col-sm-auto">
      <div class="text-right">
        <a href="#" @click.stop.prevent="addMention">{{ name }}</a>
      </div>
      <div>{{ createdAt }}</div>
      <div class="text-right">
        <a href="#">*</a>
        <a href="#">[x]</a>
      </div>
    </div>
    <div class="col">
      <div class="row">
        <div class="col-sm-12">
          {{ contents }}
        </div>
      </div>

      <div v-if="isTextOpened">
        <sub-firewood></sub-firewood>
      </div>

      <div v-if="isImgOpened" class="row no-gutters">
        <div class="col-sm-12">
          Image Area
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SubFirewood from "./SubFirewood"
import EventBus from "../EventBus"

export default {
  name: "firewood",
  components: {
    SubFirewood
  },
  props: [
    "contents", "createdAt", "id", "imageAdultFlg", "imageUrl", "isDm",
    "name", "mentionedNames", "prevMtId", "rootMtId", "userId",
    "isImgOpened", "isTextOpened", "persisted"
  ],
  data() {
    return {
      subfws: [],
      isLoading: false
    }
  },
  computed: {
    isDeletable() {
      return true
    }
  },
  methods: {
    addMention() {
      const prefix = this.isDm ? "!" : "@"
      EventBus.$emit("add-mention", {
        names: this.mentionedNames.concat([prefix + this.name]),
        id: this.id
      })
    },
    handleDelete() {
      this.$emit("delete")
    },
    handleClickUsername() {
      this.$emit("clkusername")
    },
    handleToggleSubView() {
      this.$emit("togglesubview")
    }
  }
}
</script>

<style>
</style>
