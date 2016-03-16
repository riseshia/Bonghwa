(function ($) {
  "use strict"

  app.UsersView = Backbone.View.extend({
    el: "#users",

    userTemplate: _.template($("#user-template").html()),

    initialize: function () {
      this.$header = this.$("#users-header")
      this.$body = this.$("#users-body")

      this.listenTo(app.users, "reset", this.addAll)
    },

    addAll: function () {
      this.$body.html("")
      $("#users-body-mobile").html("")

      this.$header.html("접속자(" + app.users.length + "명)")
      $("#users-header-mobile").html("접속자(" + app.users.length + "명)")

      _.each(this.currentList, (view) => { view.remove() })
      _.each(this.currentMobileList, (view) => { view.remove() })

      this.currentList = []
      this.currentMobileList = []
      const $mobileThis = $("#users-body-mobile")
      app.users.each(function (user) {
        const view = new app.UserView({ model: user })
        this.$body.append(view.render().el)
        this.currentList.push(view)

        const mobileView = new app.UserMobileView({ model: user })
        $mobileThis.append(mobileView.render().el)
        this.currentMobileList.push(mobileView)
      }, this)
    },

    clkUsername: function () {
      const arr = [this.model.get("name")]
      app.FirewoodsView.trigger("form:appendMt", arr)
    }
  })
})(jQuery)