<template>
  <div :class="{ row: true, 'text-muted': isDeleted || !persisted || isDm }">
    <div class="col-sm-auto">
      <div class="text-right">
        <a href="#" @click.stop.prevent="addMention">{{ name }}</a>
      </div>
      <div>{{ createdAt }}</div>
      <div class="text-right">
        <a href="#">*</a>
        <a v-if="isDeletable" @click.stop.prevent="destroy"
           href="#">[x]</a>
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
import Actions from "../Actions"

export default {
  name: "firewood",
  components: {
    SubFirewood
  },
  props: [
    "contents", "createdAt", "id", "imageAdultFlg", "imageUrl", "isDm",
    "name", "mentionedNames", "prevMtId", "rootMtId", "userId",
    "isDeletable", "isImgOpened", "isTextOpened", "persisted"
  ],
  data() {
    return {
      subfws: [],
      isLoading: false,
      isDeleted: false
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
    destroy() {
      /* eslint-disable no-alert */
      if (!confirm("삭제하시겠습니까?")) {
        return
      }

      Actions.destroyFirewood(this)
    }
  }
}
</script>

<style>
</style>
