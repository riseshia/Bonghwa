<template>
  <!-- Start Main Contents  -->
  <div id="app" class="container-fluid">
    <div class="row clearfx">
      <div class="col-sm-9">
        <firewood-form></firewood-form>
        <informations></informations>
        <stack-status></stack-status>
        <firewoods
          :isLiveStreaming="global.isLiveStreaming"
          :isImageAutoOpen="global.isImageAutoOpen"
        ></firewoods>
      </div>

      <div class="col-sm-3">
        <div class="row">
          <div class="col-sm-12">
            <h3>Bonghwa</h3>
            <ul class="nav flex-column">
              <li class="nav-item">
                <a class="nav-link active" href="#"
                   @click.prevent.stop="changeType(1)">Now</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#"
                   @click.prevent.stop="changeType(2)">Mt</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#"
                   @click.prevent.stop="changeType(3)">Me</a>
              </li>
            </ul>
          </div>
        </div>
        <users></users>
        <div class="row">
          <div class="col-sm-12">
            <div id="widget">
              <a class="twitter-timeline"
                 href="https://twitter.com/"
                 :data-widget-id="app.twitterIdentifier">Widget</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- End Main Contents  -->
</template>

<script>
import EventBus from "./EventBus"
import Actions from "./Actions"

import Firewoods from "./components/Firewoods"
import StackStatus from "./components/StackStatus"
import FirewoodForm from "./components/FirewoodForm"
import Informations from "./components/Informations"
import Users from "./components/Users"

export default {
  name: "app",
  components: {
    Firewoods,
    StackStatus,
    FirewoodForm,
    Informations,
    Users
  },
  beforeCreate() {
    const vm = this
    EventBus.$on("app", (obj) => {
      vm.app = obj
    })
    EventBus.$on("global", (obj) => {
      vm.global = obj
    })
  },
  mounted() {
    const script = document.createElement("script")
    /* eslint-disable quotes */
    script.innerHTML = `!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");`
    window.$("#widget").append(script)
  },
  data() {
    return {
      global: {},
      app: {}
    }
  },
  methods: {
    changeType(type) {
      Actions.changeType(type)
    }
  }
}
</script>

<style>
@import '../node_modules/bootstrap/dist/css/bootstrap.css'
</style>
