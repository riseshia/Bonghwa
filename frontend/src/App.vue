<template>
  <!-- Start Main Contents  -->
  <div id="app" class="container-fluid">
    <div class="row clearfx">
      <div class="col-sm-9">
        <firewood-form></firewood-form>
        <informations></informations>
        <firewoods></firewoods>
      </div>

      <div class="col-sm-3">
        <div class="row">
          <div class="col-sm-12">
            <h3>Bonghwa</h3>
            <ul class="nav flex-column">
              <li class="nav-item">
                <a class="nav-link active" href="#">Now</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Me</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Mt</a>
              </li>
            </ul>
          </div>
        </div>
        <users></users>
        <div class="row">
          <div class="col-sm-12">
            Twitter Widget
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- End Main Contents  -->
</template>

<script>
import Firewoods from "./components/Firewoods"
import FirewoodForm from "./components/FirewoodForm"
import Informations from "./components/Informations"
import Users from "./components/Users"

export default {
  name: "app",
  components: {
    Firewoods,
    FirewoodForm,
    Informations,
    Users
  },
  data() {
  }
}
</script>

<style>
@import '../node_modules/bootstrap/dist/css/bootstrap.css'
</style>
