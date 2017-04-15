<template>
  <!-- Start Main Contents  -->
  <div id="app" class="container-fluid">
    <div class="row no-gutters">
      <div class="col-sm-9">
        <firewood-form
          :user="user"
          :global="global"
        ></firewood-form>
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

      <nav-tab
        :app="app"
        :global="global"
      ></nav-tab>
    </div>
  </div>
  <!-- End Main Contents  -->
</template>

<script>
import EventBus from "./EventBus"
import Actions from "./Actions"
import Store from "./Store"

import Firewoods from "./components/Firewoods"
import StackStatus from "./components/StackStatus"
import FirewoodForm from "./components/FirewoodForm"
import Informations from "./components/Informations"
import NavTab from "./components/NavTab"
import NativeComponent from "./components/NativeComponent"
import Channel from "./Channel"

export default {
  name: "app",
  components: {
    Firewoods,
    StackStatus,
    FirewoodForm,
    Informations,
    NavTab
  },
  beforeCreate() {
    const vm = this
    EventBus.$on("app", (obj) => {
      vm.app = obj
    })
    EventBus.$on("user", (obj) => {
      vm.user = obj
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
      global: Store.getState("global"),
      app: {},
      user: {},
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
      /* eslint-disable no-alert */
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

/* Bootstrap Overriding */
.container-fluid {
  padding-left: 0;
  padding-right: 0;
}

body, .form-control, .btn {
  font-size: 0.9rem;
}
/* Bootstrap Overriding done */
</style>
