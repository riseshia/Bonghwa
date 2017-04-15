<template>
  <div class="col-sm-3">
    <div class="row no-gutters nav-menu">
      <div class="col-sm-12">
        <h3 class="nav-brand bg-inverse">
          <a class="text-white" target="_blank" :href="app.home_link">
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
            <ul v-if="optionsOpened" class="list-unstyled options-menu">
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
    <div class="row no-gutters widget-area">
      <div class="col-sm-12" id="widget">
        <a class="twitter-timeline"
           href="https://twitter.com/"
           :data-widget-id="app.widget_link">Widget</a>
      </div>
    </div>
  </div>
  <!-- End Main Contents  -->
</template>

<script>
import Actions from "../Actions"
import Users from "./Users"

export default {
  name: "nav-tab",
  components: {
    Users
  },
  mounted() {
    const script = document.createElement("script")
    /* eslint-disable quotes */
    script.innerHTML = `!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");`
    window.$("#widget").append(script)
  },
  props: ["app", "global"],
  data() {
    return {
      optionsOpened: false
    }
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

<style scoped>
.nav-menu a {
  color: #333;
}

.nav-menu h3 {
  margin-bottom: 0;
  padding: 10px 20px;
}

.nav-menu .nav-pills .nav-link {
  border-radius: 0;
}

.nav-menu .nav-pills .nav-link.active {
  background-color: #ddd;
  color: #333;
}

.dropdown-toggle {
  padding-bottom: 2px;
}

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

.options-menu {
  text-indent: 30px;
}

.widget-area {
  border-top: 1px solid #eee;
}

.nav-brand {
  font-weight: normal;
}
</style>
