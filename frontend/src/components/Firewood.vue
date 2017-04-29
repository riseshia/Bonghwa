<template>
  <div :class="classObject" @click="toggleSelf">
    <div class="col-sm-auto col-auto flex-sm-first flex-first name-area">
      <a href="#" @click.stop.prevent="addMention">{{ name }}</a>
    </div>
    <div class="col-sm col-12 flex-sm-unordered flex-last">
      <span class="message" v-html="parsedContents"></span>
      <span
        v-if="hasImage"
        :class="{ 'link-url-danger': sensitiveFlg, 'link-url': !sensitiveFlg }">{{ imageName }}</span>
      <a v-if="isDeletable" @click.stop.prevent="destroy"
         class="link-url" href="#">[x]
      </a>
      <transition name="sliding">
        <div v-if="isImgOpened">
          <div v-if="isTextOpened && parents.length">
            <sub-firewood :firewoods="parents"></sub-firewood>
          </div>

          <div v-if="isImgOpened && hasImage" class="row no-gutters">
            <div class="col-sm-12">
              <figure class="figure">
                <img class="figure-img" :src="imageUrl">
                <figcaption class="figure-caption text-center">
                  <a :href="imageUrl" @click.stop="true" class="link-url"
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
    <div
      v-if="isLastRecent"
      class="col-sm-12 col-12 flex-last flex-sm-last text-center border-recent-fws">
      New!!
    </div>
  </div>
</template>

<script>
import SubFirewood from "./SubFirewood"
import FirewoodFn from "../FirewoodFn"
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
    "contents", "createdAt", "id", "sensitiveFlg", "image", "isDm",
    "name", "mentionedNames", "prevMtId", "rootMtId", "parents", "userId",
    "isDeletable", "isImageAutoOpen", "status", "isLastRecent",
    "parentNotEnough", "isMentioned"
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
      return this.image ? `[이미지: ${this.image.name}]` : ""
    },
    imageUrl() {
      return this.image ? this.image.url : ""
    },
    hasImage() {
      return this.image !== null
    },
    isMuted() {
      return this.isDeleted || FirewoodFn.isPending(this) || this.isDm
    },
    isOpenable() {
      return this.hasImage || this.rootMtId !== 0
    },
    isOpened() {
      return this.isImgOpened || this.isTextOpened
    },
    parsedContents() {
      const classes = []
      if (this.sensitiveFlg) { classes.push("link-url-danger") }
      return autolink(this.contents, { classes })
    },
    classObject() {
      return {
        "d-flex": true,
        "justify-content-between": true,
        "no-gutters": true,
        "text-muted": this.isMuted,
        "last-recent-fw": this.isLastRecent,
        mentioned: this.isMentioned && !FirewoodFn.isPending(this),
        firewood: true,
        row: true
      }
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
        names: [prefix + this.name].concat(this.mentionedNames),
        rootMtId: this.rootMtId,
        id: this.id
      })
    },
    toggleSelf() {
      if (!this.isOpenable) { return }
      const nextState = !this.isOpened
      if (nextState && this.parentNotEnough) {
        Actions.fetchParents(this.id, this.rootMtId)
      }

      this.isImgOpened = nextState
      this.isTextOpened = nextState
    },
    destroy() {
      /* eslint-disable no-alert */
      if (!confirm("삭제하시겠습니까?")) {
        return
      }

      this.isDeleted = true
      Actions.destroyFirewood(this)
    }
  }
}
</script>

<style lang="scss" scoped>
.firewood {
  border-bottom: 1px solid #ddd;
  padding: 3px 7px 2px;

  &.last-recent-fw {
    border-bottom: 1px solid #ffc9c9;
  }

  .border-recent-fws {
    color: #fa5252;
  }

  &.mentioned {
    background-color: #e8f7ff;
  }
}

.text-small {
  font-size: 80%;
}

.message {
  padding-left: 5px;
  word-break: break-all;
  word-wrap: break-word;
}

.datetime-area {
  padding-left: 5px;
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
