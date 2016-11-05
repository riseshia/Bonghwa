(function ($) {
  "use strict"

  app.AppView = Backbone.View.extend({
    el: "body",

    initialize: function () {
      app.originTitle = $("title").text()

      // load initial state from localStorage
      if (localStorage.getItem("auto_image_open") === "1") {
        app.defaultIsOpened = true
      } else {
        app.defaultIsOpened = false
      }

      const $info = this.$("#info")
      if ($info.length) {
        $info.html($info.html().autoLink({ target: "_blank", rel: "nofollow" }))
        $info.find(".link_url").click(e => { e.stopPropagation() })
      }

      $(document).keycut()
      app.render()
    },

    events: {
      "click #img_auto_open_op": "toggleImgAutoOpen",
      "click #live_stream_op": "toggleLiveStream",
      "click #focus_hotkey": "focusToInput",
      "click #refresh_hotkey": "refreshTL",
      "click #info": "removeInfo"
    },

    toggleImgAutoOpen: function (e) {
      if (e) { e.preventDefault() }

      const $iao = this.$("#img_auto_open_op")
      const newState = (localStorage.getItem("auto_image_open") == "1" ? "0" : "1")
      localStorage.setItem("auto_image_open", newState)
      let msg

      $iao.toggleClass("true")
      if (newState === "1") {
        $iao.html($iao.html() + "<span class='glyphicon glyphicon-ok'></span>")
        msg = "이미지 자동 열기가 활성화되었습니다."
        app.unfoldImageAll()
      } else {
        $iao.find(".glyphicon-ok").remove()
        msg = "이미지 자동 열기가 비활성화되었습니다."
        app.foldImageAll()
      }

      this.notifyWithWindow(msg, "alert-info")
      return this
    },

    toggleLiveStream: function (e) {
      if ( e ) { e.preventDefault() }

      const $ls = this.$("#live_stream_op")
      const newState = (localStorage.getItem("live_stream") == "1" ? "0" : "1")
      localStorage.setItem("live_stream", newState)
      let msg

      $ls.toggleClass("true")
      if (newState == "1") {
        $ls.html($ls.html() + "<span class='glyphicon glyphicon-ok'></span>")
        msg = "Live Stream이 활성화되었습니다."
        app.channel.toggleLiveStream(true)
      } else {
        $ls.find(".glyphicon-ok").remove()
        msg = "Live Stream이 비활성화되었습니다."
        app.channel.toggleLiveStream(false)
      }

      this.notifyWithWindow(msg, "alert-info")
      return this
    },

    refreshTL: function (e) {
      e.preventDefault()
      app.channel.load()
      return this
    },

    focusToInput: function (e) {
      e.preventDefault()

      $("html, body").animate({scrollTop: 0}, 600)
      app.util.placeCaretAtEnd("contents")

      return this
    },

    notifyWithWindow: function (msg, option) {
      const $alert = $("<div class='alert' display='none;'></div>")
      const $timeline = $("#timeline")
      const left = $timeline.offset().left + $timeline.width()/2

      $alert
        .appendTo("body")
        .html(msg)
        .addClass(option)
        .css({left: left, top: 80})
        .clearQueue()
        .stop()
        .fadeIn(600)
        .delay(1000)
        .fadeOut(1000)

      return this
    },

    removeInfo: function () {
      const $info = this.$("#info")
      $info.slideUp( () => {
        $info.remove()
      })
    }
  })
})(jQuery)
