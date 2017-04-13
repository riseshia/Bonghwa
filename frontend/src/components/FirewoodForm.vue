<template>
  <form class="form-horizontal"
        role="form"
        id="new_firewood"
        enctype="multipart/form-data"
        action="aapi/firewoods"
        accept-charset="UTF-8">
    <div class="row">
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
    <div class="row justify-content-between">
      <div class="col">
        <label class="custom-file">
          <input type="file" name="firewood[image]" class="custom-file-input">
          <span class="custom-file-control">Pic</span>
        </label>
        <label class="form-check-label">
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
</template>

<script>
import Agent from "../Agent"
import Store from "../Store"
import EventBus from "../EventBus"
import FirewoodSerializer from "../FirewoodSerializer"

const CONTENTS_MAX_LEN = 150

export default {
  name: "firewood-form",
  mounted() {
    this.form = window.$("#new_firewood")
    EventBus.$on("add-mention", this.addMention)
    Agent.setupForm(this.form)
  },
  data() {
    return {
      adultFlg: false,
      prevMtId: 0,
      rootMtId: 0,
      contents: ""
    }
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
    }
  },
  methods: {
    addMention(data) {
      const uniqueNames = window.$.unique(data.names)
      this.contents = `${uniqueNames.join(" ")} ${this.contents}`
      this.prevMtId = this.id
      this.rootMtId = this.rootMtId || this.id || 0
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
    submit() {
      const formData = this.formData()
      const lastFwId = Store.getState("firewoods")[0].id
      Agent.submitForm({ firewood: formData }, () => {
        const type = Store.getState("global").type
        Agent.getWithAuth(
          "firewoods/pulling",
          { after: lastFwId, type }
        ).then((json) => {
          const newFws = json.fws.map(fw => (FirewoodSerializer(fw)))
          const fws = newFws.concat(Store.getState("firewoods")).filter((fw) => {
            fw.inStack = false
            return fw.persisted
          })
          Store.setState("firewoods", fws)
        })
      })
      this.clearForm()
      formData.persisted = false
      formData.name = Store.getState("user").user_name
      formData.created_at = "--/--/-- --:--:--"
      Store.prependElement("firewoods", FirewoodSerializer(formData))
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

<style>
</style>

