(function ($) {
  "use strict"

  app.MentionsView = Backbone.View.extend({
    tagName: "li",

    initialize: function(args) {
      if ( args.fws[0] && args.fws[0].toJSON ) {
        args.fws = _.map(args.fws, (fw) => { return fw.toJSON() })
      }

      this.parentView = args.parentView
      this.fws = args.fws || []

      this.mtTemplate = _.template($("#mt-template").html())
      this.imgTemplate = _.template($("#img-template").html())
    },

    render: function () {
      this.$el.html(this.textRender() + this.imgRender())
      this.$el.addClass("list-group-item div-mention")

      return this
    },

    textRender: function () {
      const arr = _.map(this.fws, function (fw) {
        return this.mtTemplate(fw)
      }, this)
      return arr.join("")
    },

    imgRender: function () {
      const imgLink = this.parentView.model.get("img_link")
      if (imgLink != "0") {
        return this.imgTemplate({imgLink: imgLink})
      } else {
        return ""
      }
    }
  })
})(jQuery)
