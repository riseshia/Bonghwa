<template>
  <div class="form-box">
    <form class="form-horizontal bg-faded fixed-top firewood-form"
          role="form"
          id="new_firewood"
          enctype="multipart/form-data"
          action="aapi/firewoods"
          accept-charset="UTF-8">
      <div class="row no-gutters">
        <div class="col-sm-12">
          <div class="form-group">
            <input
              @keydown.enter.stop.prevent="submit"
              v-model="contents"
              id="contents"
              type="text"
              placeholder="Type..."
              class="form-control">
          </div>
        </div>
      </div>
      <div class="row no-gutters justify-content-between">
        <div class="col form-inline">
          <input id="file-input" type="file" class="custom-file-upload" name="firewood[image]">

          <label class="form-check-label adult-flg text-danger">
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
  </div>
</template>

<script>
import EventBus from "../EventBus"
import Actions from "../Actions"
import Store from "../Store"

const CONTENTS_MAX_LEN = 150

export default {
  name: "firewood-form",
  mounted() {
    this.form = window.$("#new_firewood")
    EventBus.$on("add-mention", this.addMention)
    Actions.setupForm(this)
    this.form.find("input[type=file]").customFile()
  },
  props: ["user", "global"],
  data() {
    const defaultData = {
      adultFlg: false,
      prevMtId: 0,
      rootMtId: 0,
      contents: ""
    }
    if (this.global.cachingForm) {
      return Store.fetchState("form-state", defaultData)
    }
    return defaultData
  },
  computed: {
    remainCount() {
      return CONTENTS_MAX_LEN - this.contents.length
    }
  },
  watch: {
    contents(newContents) {
      if (newContents.length > CONTENTS_MAX_LEN) {
        this.contents = newContents.slice(0, CONTENTS_MAX_LEN)
      }
      if (this.global.cachingForm) {
        Actions.saveForm(this.$data)
      }
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
      window.$("#contents").focus()
    },
    formData() {
      return {
        contents: this.contents,
        prev_mt_id: this.prevMtId,
        root_mt_id: this.rootMtId,
        image_adult_flg: this.adultFlg
      }
    },
    isValid() {
      const fileInputEl = document.getElementById("file-input")
      return fileInputEl.files.length || this.contents.length !== 0
    },
    submit() {
      if (!this.isValid()) {
        Actions.fetchFirewoods({ afterFlush: true })
      } else {
        Actions.createFirewood(this)
      }
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

<style scoped>
/* Mobile */
.form-box {
  margin-top: 119px;
}
.firewood-form {
  padding: 10px;
}

/* PC */
@media (min-width: 576px) {
  .form-box {
    margin-top: 98px;
  }

  .firewood-form {
    width: 75%;
  }
}

.form-group {
  margin-bottom: 0.5rem;
}

.adult-flg {
  margin-left: 10px;
}
</style>
