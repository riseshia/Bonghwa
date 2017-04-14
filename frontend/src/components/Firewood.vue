<template>
  <div
    :class="{ row: true,  'no-gutters': true, firewood: true, 'text-muted': isMuted }"
    @click="toggleSelf"
  >
    <div class="col-sm-12 message d-flex justify-content-between">
      <div>
        <a href="#" @click.stop.prevent="addMention">{{ name }}</a> :
        <span v-html="parsedContents"></span>
        <span
          v-if="imageUrl"
          :class="{ 'text-danger': imageAdultFlg, 'text-primary': !imageAdultFlg }">[이미지]</span>
        <a v-if="isDeletable" @click.stop.prevent="destroy"
           href="#">[x]
        </a>
      </div>
      <div class="text-small">{{ createdAt }}</div>
    </div>
    <transition name="sliding">
      <div class="col-sm-12" v-if="isImgOpened">
        <div v-if="isTextOpened && parents.length">
          <sub-firewood
            :firewoods="parents"
          ></sub-firewood>
        </div>

        <div v-if="isImgOpened && imageUrl" class="row no-gutters">
          <div class="col-sm-12">
            <figure class="figure">
              <img class="figure-img img-fluid rounded" :src="imageUrl">
              <figcaption class="figure-caption text-center">
                <a :href="imageUrl" @click.stop="true"
                   target="_blank">크게 보기</a>
              </figcaption>
            </figure>
          </div>
        </div>
      </div>
    </transition>
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
  padding-bottom: 2px;
  padding-top: 3px;
}

.message {
  padding-left: 10px;
  padding-right: 10px;
}

.text-small {
  font-size: 90%;
}

img {
  max-height: 500px;
  max-width: 500px;
}

.sliding-enter-active, .sliding-leave-active {
  transition: max-height .5s;
  overflow: hidden;
  max-height: 600px;
}
.sliding-enter, .sliding-leave-to {
  max-height: 0;
}
</style>
