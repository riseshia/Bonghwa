(function () {
  "use strict"

  const BWRouter = Backbone.Router.extend({
    routes: {
      now: "typeNow",
      mt: "typeMt",
      me: "typeMe"
    },

    typeNow: function () {
      if (app.pageType != 1) { app.channel.load(1) }
      app.pageType = 1
      this._toggleNavbarMenu(".now_nav")
    },

    typeMt: function () {
      if (app.pageType != 2) { app.channel.load(2) }
      app.pageType = 2
      this._toggleNavbarMenu(".mt_nav")
    },

    typeMe: function () {
      if (app.pageType != 3) { app.channel.load(3) }
      app.pageType = 3
      this._toggleNavbarMenu(".me_nav")
    },

    _toggleNavbarMenu: function (toggleSelector) {
      $(".all_nav").parent().removeClass("active")
      $(toggleSelector).parent().addClass("active")
    }
  })

  app.BWRouter = new BWRouter()
})()
