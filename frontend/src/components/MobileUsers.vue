<template>
  <div>
    <div id="users-header-mobile">접속자수({{title}})</div>
    <dl
      id="users-body-mobile"
      v-for="user in users"
      key="user.name">
      <dd key={user.name}>
        <user
          name="user.name"
          clkUsernameFactory="this.clkUsernameFactory"/>
      </dd>
    </dl>
  </div>
      <li
        v-for="user in users"
        key="user.name"
        class="list-group-item div-username">
        <user
          name="user.name"
          clkUsernameFactory="this.clkUsernameFactory"/>
      </li>
    </ul>
  </div>
</template>

<script>
import User from "./User"

export default {
  name: "mobile-users",
  components: {
    User
  },
  props: ["users"],
  methods: {
    // clkUsernameFactory(name) {
    //   return () => {
    //     const arr = [`@${name}`]
    //     window._appendMt(arr)
    //     $("#mobileNavmenu").offcanvas("hide")
    //   }
    // }
  }
}
</script>

<style>
</style>
