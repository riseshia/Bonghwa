<template>
  <form class="form-horizontal"
        role="form"
        id="new_firewood"
        enctype="multipart/form-data"
        action="api/new"
        accept-charset="UTF-8"
        method="post">
    <div class="row">
      <div class="col-sm-12">
        <div class="form-group">
          <textarea class="form-control"></textarea>
        </div>
      </div>
    </div>
    <div class="row justify-content-between">
      <div class="col">
        <label class="custom-file">
          <input type="file" class="custom-file-input">
          <span class="custom-file-control">Pic</span>
        </label>
        <label class="form-check-label">
          <input class="form-check-input" type="checkbox" value="">
            후방주의
        </label>
      </div>
      <div class="col-sm-auto">
        <span>150</span>
        <a class="btn btn-primary" href="#" role="button">Send</a>
      </div>
    </div>
  </form>
</template>

<script>
export default {
  name: "firewood-form"
}
</script>

<style>
</style>

