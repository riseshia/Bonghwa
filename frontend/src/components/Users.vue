<template>
  <div class="row no-gutters current-users">
    <div class="col-sm-12">
      <h4>Users({{ users.length }}명)</h4>

      <ul class="list-unstyled">
        <li v-for="user in users" :key="user.name">
          <a href="#" @click.stop.prevent="addMention">@{{ user.name }}</a>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import EventBus from "../EventBus"

export default {
  name: "users",
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
    addMention(event) {
      EventBus.$emit("add-mention", { names: [`${event.target.innerText}`] })
    }
  }
}
</script>

<style lang="scss" scoped>
h4 {
  background-color: #212529;
  color: #f8f9fa;
  margin-bottom: 0;
  padding: 10px 15px;
  font-weight: normal;
}

ul {
  padding: 5px 0;
  margin-bottom: 0;

  li {
    text-indent: 15px;
  }
}
</style>
