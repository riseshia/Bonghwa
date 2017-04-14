<template>
  <!-- Start Main Contents  -->
  <div id="app" class="container-fluid">
    <div class="row clearfx">
      <div class="col-sm-9">
        <firewood-form></firewood-form>
        <informations></informations>
        <stack-status
          :stackedCount="stackedCount"
        ></stack-status>
        <firewoods
          :isLiveStreaming="global.isLiveStreaming"
          :isImageAutoOpen="global.isImageAutoOpen"
          :firewoods="visibleFws"
        ></firewoods>
      </div>

      <div class="col-sm-3">
        <div class="row">
          <div class="col-sm-12">
            <h3>
              <a target="_blank" :href="app.home_link">
                {{ app.home_name }}
              </a>
            </h3>
            <ul class="nav flex-column nav-pills">
              <li class="nav-item">
                <a :class="navClassObject(1)" href="#"
                   @click.prevent.stop="changeType(1)">Now</a>
              </li>
              <li class="nav-item">
                <a :class="navClassObject(2)" href="#"
                   @click.prevent.stop="changeType(2)">Mt</a>
              </li>
              <li class="nav-item">
                <a :class="navClassObject(3)" href="#"
                   @click.prevent.stop="changeType(3)">Me</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#"
                   @click.prevent.stop="signOut">Exit</a>
              </li>
              <li class="nav-item">
                <a class="nav-link dropdown-toggle" href="#"
                   @click.prevent.stop="toggleOptionsMenu">Options</a>
                <ul v-if="optionsOpened">
                  <li>
                    <a href="#"
                       @click.prevent.stop="toggleOption('isImageAutoOpen')">
                      [{{ global.isImageAutoOpen ? "o" : "x" }}]
                      Image auto open
                    </a>
                  </li>
                  <li>
                    <a href="#"
                       @click.prevent.stop="toggleOption('isLiveStreaming')">
                      [{{ global.isLiveStreaming ? "o" : "x" }}]
                      Live Stream
                    </a>
                  </li>
                </ul>
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
                 :data-widget-id="app.widget_link">Widget</a>
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
import NativeComponent from "./components/NativeComponent"
import Channel from "./Channel"

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
    EventBus.$on("firewoods", (firewoods) => {
      vm.firewoods = firewoods
    })
    EventBus.$on("stackedCount", (count) => {
      vm.stackedCount = count
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
      global: {
        isImageAutoOpen: false,
        isLiveStreaming: false
      },
      app: {},
      firewoods: [],
      stackedCount: 0,
      optionsOpened: false
    }
  },
  computed: {
    visibleFws() {
      return this.firewoods.filter(fw => (!fw.inStack))
    }
  },
  beforeRouteEnter(to, from, next) {
    next(() => {
      Actions.loadApplication().then(() => {
        Channel.start()
        NativeComponent.start()
        Actions.refreashApplication()
        next()
      })
    })
  },
  methods: {
    changeType(type) {
      Actions.changeType(type)
    },
    toggleOptionsMenu() {
      this.optionsOpened = !this.optionsOpened
    },
    toggleOption(key) {
      Actions.toggleGlobalOption(key)
    },
    navClassObject(type) {
      return {
        'nav-link': true,
        active: this.global.type === type
      }
    },
    signOut() {
      if (confirm("정말로 로그아웃하시겠어요?")) {
        const router = this.$router
        Actions.destroySession().then(() => {
          router.push("/sign_in")
        })
      }
    }
  }
}
</script>

<style>
@import '../node_modules/bootstrap/dist/css/bootstrap.css';

.dropdown-toggle::after {
    display: inline-block;
    width: 0;
    height: 0;
    margin-left: .3em;
    vertical-align: middle;
    content: "";
    border-top: .3em solid;
    border-right: .3em solid transparent;
    border-left: .3em solid transparent;
}
</style>
