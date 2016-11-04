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
    }
  })
})()
