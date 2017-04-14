<template>
  <div
    :class="{ row: true, firewood: true, 'text-muted': isMuted }"
    @click.stop.prevent="toggleSelf"
  >
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
          <span v-html="parsedContents"></span>
          <span v-if="imageUrl" :class="{ 'text-danger': imageAdultFlg }">[이미지]</span>
        </div>
      </div>

      <div v-if="isTextOpened">
        <sub-firewood
          :firewoods="parents"
        ></sub-firewood>
      </div>

      <div v-if="isImgOpened && imageUrl" class="row no-gutters">
        <div class="col-sm-12">
          <img :src="imageUrl">
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SubFirewood from "./SubFirewood"
import EventBus from "../EventBus"
import Actions from "../Actions"
import autolink from "../utils/autolink"

export default {
  name: "firewood",
  components: {
    SubFirewood
  },
  props: [
    "contents", "createdAt", "id", "imageAdultFlg", "imageUrl", "isDm",
    "name", "mentionedNames", "prevMtId", "rootMtId", "parents", "userId",
    "isDeletable", "persisted", "isImageAutoOpen"
  ],
  data() {
    return {
      isImgOpened: this.$props.isImageAutoOpen,
      isTextOpened: false,
      isDeleted: false
    }
  },
  computed: {
    isMuted() {
      return this.isDeleted || !this.persisted || this.isDm
    },
    isOpened() {
      return this.isImgOpened || this.isTextOpened
    },
    parsedContents() {
      const classes = []
      if (this.imageAdultFlg) { classes.push("text-danger") }
      return autolink(this.contents, { classes })
    }
  },
  methods: {
    addMention() {
      const prefix = this.isDm ? "!" : "@"
      EventBus.$emit("add-mention", {
        names: this.mentionedNames.concat([prefix + this.name]),
        rootMtId: this.rootMtId,
        id: this.id
      })
    },
    toggleSelf() {
      let nextState = true
      if (this.isOpened) {
        nextState = false
      }
      this.isImgOpened = nextState
      this.isTextOpened = nextState
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
