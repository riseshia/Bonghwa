<template>
  <!-- Start Main Contents  -->
  <div id="app" class="container-fluid">
    <div class="row no-gutters">
      <div class="col-1 col-sm"></div>
      <div class="col-10 col-sm-3">
        <div style="height: 100px"></div>
        <h3 class="text-white" style="text-align: center;">Login</h3>
        <div style="height: 20px"></div>
        <form @submit.stop.prevent="submit">
          <div :class="rowClasses">
            <input
              v-model="loginId"
              type="text" :class="inputClasses" placeholder="ID">
          </div>
          <div :class="rowClasses">
            <input
              v-model="password"
              type="password" :class="inputClasses" placeholder="Password">
            <div v-if="!isValid"
              class="form-control-feedback">
              아이디나 패스워드가 일치하지 않습니다.
            </div>
          </div>
          <div class="form-group row justify-content-between">
            <small class="form-text text-muted">
              <a href="/users/sign_up" class="text-white">Sign-up</a>
            </small>
            <button type="submit" class="btn btn-primary">Submit</button>
          </div>
        </form>
      </div>
      <div class="col-1 col-sm"></div>
    </div>
  </div>
  <!-- End Main Contents  -->
</template>

<script>
import Agent from "./Agent"

export default {
  name: "sign-in",
  data() {
    return { loginId: "", password: "", isValid: true }
  },
  computed: {
    rowClasses() {
      return {
        row: true,
        "form-group": true,
        "has-danger": !this.isValid
      }
    },
    inputClasses() {
      return { "form-control": true, "form-control-danger": !this.isValid }
    }
  },
  beforeRouteEnter(to, from, next) {
    window.$("body").addClass("bg-inverse")
    next()
  },
  beforeRouteLeave(to, from, next) {
    window.$("body").removeClass("bg-inverse")
    next()
  },
  methods: {
    submit() {
      const vm = this
      Agent.authenticate(this.loginId, this.password).then((result) => {
        if (result) {
          vm.$router.push("/")
        } else {
          this.isValid = false
        }
      })
    }
  }
}
</script>

<style scoped>
@import '../node_modules/bootstrap/dist/css/bootstrap.css';

.form-control {
  background-color: #eee;
}
</style>
