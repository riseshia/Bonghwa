<template>
  <!-- Start Main Contents  -->
  <div id="app" class="container-fluid">
    <div class="row no-gutters d-flex">
      <div class="col-sm-9 flex-last flex-sm-first">
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
          :firewoods="firewoods"
        ></firewoods>
      </div>

      <nav-tab
        :app="app"
        :global="global"
        :user="user"
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
    // Widget
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
  beforeRouteEnter(to, from, next) {
    next(() => {
      Actions.fetchApplication()
      next()
    })
  },
  beforeRouteLeave(to, from, next) {
    next(() => {
      Actions.stopApplication()
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
    }
  }
}
</script>

<style lang="scss">
@import '../node_modules/bootstrap/dist/css/bootstrap.css';

/* Bootstrap Overriding */
.container-fluid {
  padding-left: 0;
  padding-right: 0;
}

body, .form-control, .btn {
  font-size: 0.9rem;
}

body {
  color: #343a40; /* Gray-8 */
}

a {
  color: #212529; /* Gray-9 */

  &:focus, &:hover {
    color: #212529; /* Gray-9 */
  }
}

.link-url {
  color: #1c7cd6; /* Blue-7 */

  &:focus, &:hover {
    color: #1b6ec2; /* Blue-8 */
  }
}

.link-url-danger {
  color: #fa5252; /* Red-6 */
  &:focus, &:hover {
    color: #f03e3e; /* Red-7 */
  }
}

.alert-info {
  background-color: #ccedff; /* Blue-1 */
  color: #1b6ec2; /* Blue-8 */
}
/* Bootstrap Overriding done */

/* Global transtions */
.sliding-enter-active, .sliding-leave-active {
  transition: max-height .5s;
  overflow: hidden;
  max-height: 600px;
}
.sliding-enter, .sliding-leave-to {
  max-height: 0;
}
</style>
