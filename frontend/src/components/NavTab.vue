<template>
  <div class="col-sm-3 flex-first flex-sm-last">
    <div class="padding-for-navtab"></div>

    <div :class="{'navtab': true, 'navtab-in-mobile': navTabOpenedInMobile}">
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
              <a class="nav-link dropdown-toggle" href="#"
                 @click.prevent.stop="toggleOptionsMenu">Options</a>
              <ul v-if="optionsOpened" class="list-unstyled options-menu">
                <li>
                  <a href="#"
                     @click.prevent.stop="toggleOption('isImageAutoOpen')">
                    [{{ global.isImageAutoOpen ? "o" : "x" }}]
                    Image auto open (2)
                  </a>
                </li>
                <li>
                  <a href="#"
                     @click.prevent.stop="toggleOption('isLiveStreaming')">
                    [{{ global.isLiveStreaming ? "o" : "x" }}]
                    Live Stream (3)
                  </a>
                </li>
                <li>
                  <a href="#"
                     @click.prevent.stop="toggleOption('cachingForm')">
                    [{{ global.cachingForm ? "o" : "x" }}]
                    메시지 임시 저장하기
                  </a>
                </li>
                <li>
                  <a href="#">
                    [ ] 입력창으로 커서 옮기기 (4)
                  </a>
                </li>
              </ul>
            </li>
            <li class="nav-item">
              <a class="nav-link dropdown-toggle" href="#"
                 @click.prevent.stop="toggleEtcMenu">Etc</a>
              <ul v-if="etcOpened" class="list-unstyled options-menu">
                <li>
                  <a class="nav-link" :href="passwordChangePath">Password Change</a>
                </li>
                <li>
                  <a class="nav-link" href="#"
                     @click.prevent.stop="signOut">Exit</a>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
      <users></users>
      <div class="row no-gutters last-updated text-center hidden-sm-down">
        <div class="col-sm-12">
          Last Updated at - {{ lastUpdated }}
        </div>
      </div>
      <div class="row no-gutters widget-area hidden-sm-down">
        <div class="col-sm-12" id="widget">
          <a class="twitter-timeline"
             href="https://twitter.com/"
             :data-widget-id="app.widget_link">Widget</a>
        </div>
      </div>
    </div>
    <div class="row no-gutters mobile-navtab-toggle text-center hidden-sm-up">
      <div class="col-sm-12" @click="toggleNavTabMenu">
        {{ navTabOpenedInMobile ? "&gt;--&lt;" : "&lt;--&gt;" }}
      </div>
    </div>
  </div>
  <!-- End Main Contents  -->
</template>

<script>
import Actions from "../Actions"
import EventBus from "../EventBus"
import Users from "./Users"

export default {
  name: "nav-tab",
  components: {
    Users
  },
  created() {
    EventBus.$on("fetch-firewoods-success", this.touchLastUpdated)
  },
  mounted() {
    const script = document.createElement("script")
    /* eslint-disable quotes */
    script.innerHTML = `!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");`
    window.$("#widget").append(script)
  },
  props: ["app", "global", "user"],
  data() {
    return {
      optionsOpened: false,
      etcOpened: false,
      navTabOpenedInMobile: false,
      lastUpdated: ""
    }
  },
  computed: {
    passwordChangePath() {
      return `/users/${this.$props.user.user_id}/edit`
    }
  },
  methods: {
    touchLastUpdated() {
      this.lastUpdated =
        (new Date()).toLocaleString().split(" ").slice(1)
        .join(" ")
    },
    changeType(type) {
      Actions.changeType(type)
    },
    toggleOptionsMenu() {
      this.optionsOpened = !this.optionsOpened
    },
    toggleOption(key) {
      Actions.toggleGlobalOption(key)
    },
    toggleEtcMenu() {
      this.etcOpened = !this.etcOpened
    },
    toggleNavTabMenu() {
      this.navTabOpenedInMobile = !this.navTabOpenedInMobile
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

<style lang="scss" scoped>
/* Mobile */
@media (max-width: 576px) {
  .navtab {
    max-height: 0;
    overflow: hidden;
    transition: max-height 1s;
  }

  .navtab-in-mobile {
    max-height: 1000px;
    transition: max-height 1s;
  }

  .padding-for-navtab {
    margin-top: 120px;
  }

  .mobile-navtab-toggle {
    background-color: #343a40;
    color: #e9ecef;
    padding: 5px 0;
  }
}

/* PC */
.nav-menu {
  a {
    color: #333;
  }

  h3 {
    margin-bottom: 0;
    padding: 10px 20px;
  }
}

.nav-menu .nav-pills {
  padding-bottom: 10px;

  .nav-link {
    border-radius: 0;

    &.active {
      background-color: #dee2e6;
      color: #343a40;
    }
  }
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

.last-updated {
  color: #868e96;
  margin: 15px 0 5px;
}

.widget-area {
  border-top: 1px solid #eee;
  padding-top: 10px;
}

.nav-brand {
  font-weight: normal;
}
</style>
