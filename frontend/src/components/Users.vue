<template>
  <div class="row">
    <div class="col-sm-12">
      <h4>Users(N)</h4>
      <ul class="list-unstyled">
        <user></user>
        <user></user>
        <user></user>
      </ul>
    </div>
  </div>
</template>

<script>
import User from "./User"

export default {
  name: "users",
  components: {
    User
  },
  props: ["users"],
  methods: {
    // clkUsernameFactory(name) {
    //   return () => {
    //     const arr = [`@${name}`]
    //     window._appendMt(arr)
    //   }
    // }
  }
}
</script>

<style>
</style>
