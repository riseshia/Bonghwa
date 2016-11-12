(function () {
  "use strict"

  const BWRouter = Backbone.Router.extend({
    routes: {
      now: "typeNow",
      mt: "typeMt",
      me: "typeMe"
    },

    typeNow: function () {
      app.pageType = 1
      this._toggleNavbarMenu(".now_nav")
      app.channel.load()
    },

    typeMt: function () {
      app.pageType = 2
      this._toggleNavbarMenu(".mt_nav")
      app.channel.load()
    },

    typeMe: function () {
      app.pageType = 3
      this._toggleNavbarMenu(".me_nav")
      app.channel.load()
    },

    _toggleNavbarMenu: function (toggleSelector) {
      $(".all_nav").parent().removeClass("active")
      $(toggleSelector).parent().addClass("active")
    }
  })

  app.BWRouter = new BWRouter()
})()
