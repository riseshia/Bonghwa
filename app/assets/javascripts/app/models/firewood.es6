(function () {
  "use strict"

  app.Firewood = Backbone.Model.extend({
    defaults: {
      id: 0,
      mt_root: 0,
      prev_mt_id: 0,
      is_dm: 0,
      user_id: 0,
      name: "initName",
      contents: "Init Contents",
      image_url: null,
      created_at: "00/00/00 00:00:00",
      isVisible: true,
      isOpened: false,
      isHighlighted: false
    }
  })
})()
