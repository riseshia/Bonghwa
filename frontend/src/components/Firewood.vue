<template>
  <div
    :class="{ row: true, 'd-flex': true, 'justify-content-between': true, 'no-gutters': true, firewood: true, 'text-muted': isMuted }"
    @click="toggleSelf"
  >
    <div class="col-sm-auto col-6 flex-sm-first flex-first name-area">
      <a href="#" @click.stop.prevent="addMention">{{ name }}</a>
    </div>
    <div class="col-sm col-12 flex-sm-unordered flex-last">
      <span class="message" v-html="parsedContents"></span>
      <span
        v-if="imageUrl"
        :class="{ 'text-danger': imageAdultFlg, 'text-primary': !imageAdultFlg }">{{ imageName }}</span>
      <a v-if="isDeletable" @click.stop.prevent="destroy"
         href="#">[x]
      </a>
      <transition name="sliding">
        <div v-if="isImgOpened">
          <div v-if="isTextOpened && parents.length">
            <sub-firewood :firewoods="parents"></sub-firewood>
          </div>

          <div v-if="isImgOpened && imageUrl" class="row no-gutters">
            <div class="col-sm-12">
              <figure class="figure">
                <img class="figure-img" :src="imageUrl">
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
    <div class="col-sm-auto col-auto flex-unordered flex-sm-last datetime-area">
      <span class="text-small hidden-xs-down">{{ date }}</span>
      <span class="text-small">{{ time }}</span>
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
  created() {
    EventBus.$on("toggle-image-on-firewood", (newState) => {
      this.isImgOpened = newState
    })
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
    imageName() {
      return `[이미지 ${this.id}]`
    },
    isMuted() {
      return this.isDeleted || !this.persisted || this.isDm
    },
    isOpenable() {
      return this.imageUrl || this.parents.length
    },
    isOpened() {
      return this.isImgOpened || this.isTextOpened
    },
    parsedContents() {
      const classes = []
      if (this.imageAdultFlg) { classes.push("text-danger") }
      return autolink(this.contents, { classes })
    },
    date() {
      return this.createdAt.split(" ")[0]
    },
    time() {
      return this.createdAt.split(" ")[1]
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
      if (!this.isOpenable) { return }
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
  padding: 3px 7px 2px;
}

.text-small {
  font-size: 80%;
}

.message {
  text-indent: 5px;
}

/* Mobile */
img {
  max-width: 95%;
}

/* PC */
@media (min-width: 576px) {
  .text-small {
    font-size: 90%;
  }

  img {
    max-height: 400px;
    max-width: 400px;
  }

  .name-area {
    width: 100px;
  }
}
</style>
