<template>
  <div :class="{'form-box': true, expanded: isExpanded}">
    <div class="fixed-top">
      <form class="form-horizontal firewood-form"
            role="form"
            id="new_firewood"
            enctype="multipart/form-data"
            action="aapi/firewoods"
            accept-charset="UTF-8">
        <div class="row no-gutters">
          <div class="col-sm-12">
            <div class="form-group">
              <textarea
                @keydown.enter.stop.prevent="submit"
                @focus="isFocused = true"
                @blur="isFocused = false"
                v-model="contents"
                id="contents"
                type="text"
                placeholder="Type..."
                class="form-control">
              </textarea>
            </div>
          </div>
        </div>
        <div class="row no-gutters justify-content-between">
          <div class="col form-inline">
            <input id="file-input" type="file" class="custom-file-upload" name="firewood[image]">

            <label class="form-check-label adult-flg link-url-danger">
              <input
                v-model="adultFlg"
                class="form-check-input" type="checkbox">
                후방주의
            </label>
          </div>
          <div class="col-sm-auto">
            <span>{{ remainCount }}</span>
            <a @click.stop.prevent="submit"
               class="btn btn-primary" href="#" role="button">Send</a>
          </div>
        </div>
      </form>
        <notifier></notifier>
    </div>
  </div>
</template>

<script>
import EventBus from "../EventBus"
import Actions from "../Actions"
import Store from "../Store"
import Notifier from "./Notifier"

const CONTENTS_MAX_LEN = 150
const MAX_FILE_SIZE = 6 * 1024 * 1024

export default {
  name: "firewood-form",
  components: {
    Notifier
  },
  mounted() {
    this.form = window.$("#new_firewood")
    EventBus.$on("add-mention", this.addMention)
    EventBus.$on("requested-form", this.clearForm)
    EventBus.$on("focus", this.focusForm)
    Actions.setupForm(this)
    this.form.find("input[type=file]").customFile()
  },
  props: ["user", "global"],
  data() {
    const defaultData = {
      adultFlg: false,
      prevMtId: 0,
      rootMtId: 0,
      contents: "",
      isFocused: false
    }
    if (this.global.cachingForm) {
      return Store.fetchState("form-state", defaultData)
    }
    return defaultData
  },
  computed: {
    remainCount() {
      return CONTENTS_MAX_LEN - this.contents.length
    },
    isExpanded() {
      if (this.contents.length > 0 || this.isFocused) { return true }
      return false
    }
  },
  watch: {
    contents(newContents) {
      if (newContents.length > CONTENTS_MAX_LEN) {
        this.contents = newContents.slice(0, CONTENTS_MAX_LEN)
      }
      if (!this.isValid()) {
        this.clearForm()
      }
      if (this.global.cachingForm) {
        Actions.saveForm(this.$data)
      }
    },
    prevMtId(newId, oldId) {
      Actions.focusFirewood(newId, oldId)
    }
  },
  methods: {
    addMention(data) {
      const currentUserName = this.user.user_name
      const uniqueNames =
        window.$.unique(data.names)
          .filter(name => (!name.endsWith(currentUserName)))
      if (uniqueNames.length > 0) {
        this.contents = `${uniqueNames.join(" ")} ${this.contents}`
      }
      this.prevMtId = data.id
      this.rootMtId = data.rootMtId || data.id || 0
      this.focusForm()
    },
    formData() {
      return {
        contents: this.contents,
        prev_mt_id: this.prevMtId,
        root_mt_id: this.rootMtId,
        sensitive_flg: this.adultFlg
      }
    },
    isValid() {
      const fileInputEl = document.getElementById("file-input")
      if (fileInputEl.files.length === 0) {
        return this.contents.length > 0
      }
      const file = fileInputEl.files[0]
      if (file.size > MAX_FILE_SIZE) {
        EventBus.$emit("notify", { message: "업로드 가능한 최대 용량은 6MB입니다." })
        return false
      }
      return true
    },
    submit() {
      if (!this.isValid()) {
        Actions.forceFetchRecentFirewoods()
      } else {
        Actions.createFirewood(this)
      }
    },
    focusForm() {
      window.$("#contents").focus()
    },
    clearForm() {
      this.form.clearForm()
      this.contents = ""
      this.prevMtId = 0
      this.rootMtId = 0
      this.adultFlg = false
    }
  }
}
</script>

<style lang="scss">
.file-upload-wrapper {
  .file-upload-input:not([title]) {
    display: none;
  }
  .input-group-btn {
    height: 35px;
  }
}
</style>
<style lang="scss" scoped>
/* PC */
.firewood-form {
  padding: 10px;
  background-color: #f8f9fa; /* Gray-0 */
  border-bottom: 1px solid #dee2e6; /* Gray-3 */
}

.form-box {
  margin-top: 117px;
}

.fixed-top {
  width: 75%;
}

textarea {
  height: 3.3rem;
}

.form-group {
  margin-bottom: 0.5rem;
}

.adult-flg {
  margin-left: 10px;
}

/* Mobile */
@media (max-width: 576px) {
  .form-box {
    margin-top: 0;
    &.expanded {
      margin-top: 1.45rem;
    }
  }

  .fixed-top {
    width: 100%;
  }

  textarea {
    height: 2.2rem;
  }
  .expanded textarea {
    height: 6.2rem;
  }
}
</style>
