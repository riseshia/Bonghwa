<template>
  <div class="row">
    <div class="col-sm-auto">
      <div>Name</div>
      <div>04/10 16:25</div>
      <div class="text-right">
        <a href="#">*</a>
        <a href="#">[x]</a>
      </div>
    </div>
    <div class="col">
      <div class="row">
        <div class="col-sm-12">
          さぁ忘れましょう　その未来が
          また血塗られて　ゆくなんて
          生ぬるい風　とぐろ巻いたら　それが多分 合図
          抜け出していって　抜け出していって　
          悲しすぎる運命から
          あなたは　奈落の花じゃない
        </div>
      </div>

      <sub-firewood></sub-firewood>

      <div class="row no-gutters">
        <div class="col-sm-12">
          Image Area
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SubFirewood from "./SubFirewood"

export default {
  name: "firewood",
  components: {
    SubFirewood
  },
  props: [
    "contents", "created_at", "id", "image_adult_flg", "image_url", "is_dm",
    "name", "prev_mt_id", "root_mt_id", "user_id", "defaultIsImgOpened"
  ],
  data() {
    return {
      subfws: [],
      isImgOpened() { return this.props.defaultIsImgOpened },
      isTextOpened: false,
      isLoading: false
    }
  },
  computed: {
    isDeletable() {
      return true
    }
  },
  methods: {
    handleDelete() {
      this.$emit("delete")
    },
    handleClickUsername() {
      this.$emit("clkusername")
    },
    handleToggleSubView() {
      this.$emit("togglesubview")
    }
  }
}
</script>

<style>
</style>
