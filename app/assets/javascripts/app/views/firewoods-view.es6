(function ($) {
  "use strict"

  app.FirewoodsView = Backbone.View.extend({
    el: "#firewoods",
    count: 0,
    maxCount: 150,

    initialize: function () {
      this.$list = this.$("#timeline")
      this.$stack = this.$("#timeline_stack")
      this.$form = this.$("#new_firewood")
      this.$input = this.$("#contents")
      this.$title = $("#title")
      this.$commitBtn = this.$("#commit")
      this.$prevMt = this.$("#firewood_prev_mt")

      this.listenTo(app.firewoods, "reset", this.addAll)
      this.listenTo(app.firewoods, "add:prepend", this.prepend)
      this.listenTo(app.firewoods, "add:append", this.append)
      this.listenTo(app.firewoods, "add:stack", this.updateStackNotice)
      this.listenTo(app.firewoods, "change:isHighlighted", this.highlightOne)

      this.listenTo(app.channel, "ajaxSuccess", this.formClear)
      this.listenTo(app.firewoods, "form:appendMt", this.appendMt)
      this.listenTo(app.firewoods, "form:flash", this.flashForm)
      this.listenTo(app.firewoods, "timeline:foldAll", this.foldAll)
      this.listenTo(app.firewoods, "timeline:unFoldAll", this.unFoldAll)

      this.$("span[rel=tooltip]").tooltip()
      this.originTitle = this.$title.text()
      
      app.channel.load()
      app.channel.setPullingTimer()
      setInterval(this.isNearBottom, 1000, this)
    },

    events: {
      "input #contents": "update_count",
      "keyup #contents": "update_count",
      "keydown #contents": "keydown",
      "paste #contents": "paste_something",
      "click #timeline_stack": "flushStack",
      "submit #new_firewood": "submit",
      "blur #contents": function () {
        if ($("#contents").html() == "<br>")
          $("#contents").html("")
      }
    },

    paste_something: function () {
      setTimeout(() => {
        $("#contents").html($("#contents").text())
        this.update_count()
      }.bind(this), 0)
    },

    keydown: function (e) {
      if (e.keyCode == window.ENTER_KEY) {
        this.submit(e)
      } else if (e.keyCode == window.ESC_KEY) {
        $("#contents").blur()
      } else {
        $("#contents").attr("bw-text-empty","false")
        e.stopPropagation()
      }
    },

    // Collection Event
    addAll: function () {
      this.$list.html("")
      app.firewoods.each(function (fw) {
        const view = new app.FirewoodView({ model: fw })
        this.$list.append(view.render().el)
      }, this)
    },

    prepend: function () {
      const fws = app.firewoods.where({ state: window.FW_STATE.IN_STACK }).reverse()
      _.each(fws, function(fw) {
        const view = new app.FirewoodView({ model: fw })
        this.$list.prepend(view.render().el)
        fw.set("state", 0)
      }, this)

      return this
    },

    append: function () {
      const fws = app.firewoods.where({ state: window.FW_STATE.IN_LOG })
      _.each(fws, function(fw) {
        const view = new app.FirewoodView({ model: fw })
        this.$list.append(view.render().el)
        fw.set("state", 0)
      }, this)

      return this
    },

    updateStackNotice: function () {
      const fws = app.firewoods.where({ state: window.FW_STATE.IN_STACK})
      if ( fws.length == 0 ) {
        return false
      }

      this.$title.html(this.originTitle + " (" + fws.length + ")")
      this.$stack
        .html("<a href='#' id='notice_stack_new'>새 장작이 " + fws.length + "개 있습니다.</a>")
        .slideDown(200)
    },

    highlightOne: function (fw) {
      fw.trigger("highlight")
    },

    submit: function (e) {
      e.preventDefault()

      if ( !this.isFormEmpty() ) {
        this.$form.ajaxSubmit(app.channel.ajaxBasicOptions)
      } else {
        app.channel.pulling(true, true)
      }
      this.$title.html(this.originTitle)
      this.$stack.html("").slideUp(200)

      return false
    },

    formClear: function() {
      this.$form.clearForm()
      this.$("#contents").html("")
      this.$("#img").val("")
      this.$(".fileinput-preview").html("")
      this.$(".fileinput")
        .removeClass("fileinput-exists")
        .addClass("fileinput-new")
      this.$(".fileinput-filename").html("")
      this.$prevMt.val("")
      this.$commitBtn.button("reset")

      this.update_count()
    },

    update_count: function () {
      const before = this.count
      let now = this.maxCount - this.$input.text().length

      if ( this.isFormEmpty() ) {
        this.$commitBtn.val("Refresh")
      } else {
        this.$commitBtn.val("Submit")
      }

      if ( now < 0 ) {
        const str = this.$input.text()
        this.$input.text(str.substr(0, this.maxCount))
        app.util.placeCaretAtEnd("contents")
        now = 0
      }

      if ( before != now ) {
        this.count = now
        this.$("#remaining_count").text(now)
      }

      if ($("#contents").text().length == 0) {
        $("#contents").attr("bw-text-empty", "true")
      } else {
        $("#contents").attr("bw-text-empty", "false")
      }
    },

    appendMt: function (names, target) {
      const user_name = $.cookie("user_name")
      let mts = _.map(names, (name) => { return name })
      mts = _.filter(mts, (mt) => { return user_name != mt.slice(1) })

      this.$prevMt.val(target)
      this.$input
        .text( mts.join(" ") + " " + this.$input.text() )
      app.util.placeCaretAtEnd("contents")
      this.update_count()
    },

    flushStack: function () {
      $(".last_top").removeClass("last_top").attr("style", "")
      $(".div-firewood:first").addClass("last_top").attr("style", "border-top-width:3px;")

      const fws = app.firewoods.filter((fw) => { return fw.get("state") == -1 && fw.get("img_link") !== "0" })
      this.prepend()
      this.$title.html(this.originTitle)
      this.$stack.html("").slideUp(200)

      if ( window.localStorage["auto_image_open"] == "1" ) {
        _.each(fws, (fw) => { fw.trigger("unFold") })
      }
    },

    foldAll: function () {
      const fws = app.firewoods.where({ isOpened: true })
      _.each(fws, ( fw ) => { fw.trigger("fold") })
    },

    unFoldAll: function () {
      const fws = app.firewoods.filter( (fw) => { return fw.get("img_link") !== "0" })
      _.each(fws, ( fw ) => { fw.trigger("unFold") })
    },

    isNearBottom: function (context) {
      const $fws = $(".firewood")
      const fws = app.firewoods
      const self = context

      if ( fws.size() == 0 || !$fws.eq(-5).isOnScreen() || fws.logGetLock || fws.length < 50 || fws.last().get("id") < 10 ) {
        return false
      }

      self.$list.append("<li class='list-group-item'><div id='div-loading' style='display: block;'>로딩중입니다.</div></li>")
      app.channel.getLogs().then(() => {
        $("#div-loading").parent().remove()
      })
    },

    isFormEmpty: function () {
      if ( this.$("div.fileinput-exists").length == 0 ) {
        const contents = this.$("#contents")
        const str = contents.text()
        if ( contents.attr("bw-text-empty") == "true" || str.search(/^\s+$/) != -1 ) {
          return true
        }
      }
      return false
    },

    flashForm: function () {
      const $formDiv = this.$form.parent()
      $formDiv.fadeOut(300).fadeIn(500)
    }
  })
})(jQuery)