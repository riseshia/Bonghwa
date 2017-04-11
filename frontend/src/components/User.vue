<template>
  <li>
    <a href="#">user1</a>
  </li>
</template>

<script>
export default {
  name: "User",
  props: ["name"],
  methods: {
    clkUsernameFactory() {
      this.$emit("clkUsername")
    }
  }
}
</script>

<style>
</style>
