(function () {
  "use strict"

  const Users = Backbone.Collection.extend({
    model: app.Users
  })

  app.users = new Users()
})()
