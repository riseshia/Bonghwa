<template>
  <div
    :class="{ row: true,  'no-gutters': true, firewood: true, 'text-muted': isMuted }"
    @click.stop.prevent="toggleSelf"
  >
    <div class="col-sm-auto meta-info">
      <div class="d-flex justify-content-between">
        <a v-if="isDeletable" @click.stop.prevent="destroy"
           href="#">[x]</a>
        <span v-if="!isDeletable"></span>
        <a href="#" @click.stop.prevent="addMention">{{ name }}</a>
      </div>
      <div class="text-small">{{ createdAt }}</div>
    </div>
    <div class="col message">
      <div class="row no-gutters">
        <div class="col-sm-12">
          <span v-html="parsedContents"></span>
          <span
            v-if="imageUrl"
            :class="{ 'text-danger': imageAdultFlg, 'text-primary': !imageAdultFlg }">[이미지]</span>
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

<style scoped>
.firewood {
  border-bottom: 1px solid #ddd;
  padding-bottom: 3px;
  padding-top: 3px;
}

.meta-info {
  width: 130px;
  padding-left: 10px;
  padding-right: 10px;
}

.message {
  padding-left: 5px;
  padding-right: 10px;
}

.text-small {
  font-size: 90%;
}

img {
  max-height: 500px;
  max-width: 500px;
}
</style>
