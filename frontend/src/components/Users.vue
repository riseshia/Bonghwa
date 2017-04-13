<template>
  <div class="row">
    <div class="col-sm-12">
      <h4>Users({{ users.length }}명)</h4>
      <ul class="list-unstyled">
        <li v-for="user in users" :key="user.name">
          <a href="#" @click.stop.prevent="addMention">{{ user.name }}</a>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import EventBus from "../EventBus"

export default {
  name: "users",
  components: {
    User
  },
  beforeCreate() {
    const vm = this
    EventBus.$on("users", (users) => {
      vm.users = users
    })
  },
  data() {
    return { users: [] }
  },
  methods: {
    addMention() {
      EventBus.$emit("add-mention", { names: [`@${this.name}`] })
    }
  }
}
</script>

<style>
</style>
