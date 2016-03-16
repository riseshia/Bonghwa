(function () {
  "use strict"

  app.Firewood = Backbone.Model.extend({
    defaults: {
      id: 0,
      mt_root: 0,
      prev_mt: 0,
      is_dm: 0,
      user_id: 0,
      name: "initName",
      contents: "Init Contents",
      img_link: "0",
      created_at: "00/00/00 00:00:00",
      state: window.FW_STATE.IN_STACK,
      isOpened: false,
      isHighlighted: false
    },

    toggleHighlight: function () {
      this.set({
        isHighlighted: !this.get("isHighlighted")
      })
    },

    activeTag: function (tag) {
      const arr = this.get("contents").split(" ")
      const oldState = this.get("isHighlighted")

      if ( ( tag != "" ? _.contains(arr, tag) : false) ^ oldState ) {
        this.toggleHighlight()
      }
      this.collection.trigger("change:isHighlighted", this, !oldState)
    },

    ajaxMtLoad: function () {
      const prev_mt = this.get("prev_mt")
      return $.get("/api/get_mt.json?prev_mt=" + prev_mt)
    }
  })
})()
