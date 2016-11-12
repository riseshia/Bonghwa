window.app = {
  defaultIsOpened: false,
  pageType: 1,
  users: [],
  firewoods: [],

  foldImageAll: () => {
    app.defaultIsOpened = false
    app.render()
  },

  unfoldImageAll: () => {
    app.defaultIsOpened = true
    app.render()
  },

  disableApp: () => {
    const $title = $("#title")
    const $panel = $(".panel-info")

    $panel.removeClass("panel-info")
          .addClass("panel-danger")
    $("#info, #div-form").css("background-color","#f2dede")
    $("#new_firewood").find("fieldset").attr("disabled","a")
    $("#commit").removeClass("btn-primary").addClass("btn-danger")
    $("#timeline_stack")
      .css("background-color","#f5c5c5")
      .html("서버와의 접속이 끊어졌습니다. 새로고침 해주세요.")
      .slideDown()
    $title.html("새로고침 해주세요.")
  },

  render: () => {
    ReactDOM.render(
      React.createElement(Firewoods, {
        firewoods: app.firewoods,
        defaultIsOpened: app.defaultIsOpened,
        originTitle: app.originTitle
      }),
      document.getElementById("firewoods-react")
    )
    ReactDOM.render(
      React.createElement(FirewoodForm, {originTitle: app.originTitle}),
      document.getElementById("new_firewood")
    )
    ReactDOM.render(
      React.createElement(Users, {users: app.users}),
      document.getElementById("users-wrapper")
    )
    ReactDOM.render(
      React.createElement(MobileUsers, {users: app.users}),
      document.getElementById("users-mobile")
    )
  }
}

const isNearBottom = () => {
  if (!app.firewoods) { return }
  const fws = app.firewoods
  const lastIdx = fws.length - 1
  const $bottomTarget = $(`.firewood[data-id=${fws[lastIdx].id}]`)

  if ($bottomTarget.length === 0 ||
      !$bottomTarget.isOnScreen() ||
      app.channel.logGetLock ||
      fws.length < 49 ||
      fws[lastIdx].id < 10 ) {
    return false
  }
  app.channel.getLogs()
}

$(() => {
  "use strict"
  if (document.getElementById("firewoods") === null) { return }

  new app.AppView({}, {})

  app.channel = new app.Channel()
  app.channel.load()
  app.channel.setPullingTimer()
  setInterval(isNearBottom, 1000)
  Backbone.history.start()

  $(".all_nav").click(e => {
    const page = app.pageType
    const clicked = (() => {
      if ($(".now_nav").parent().hasClass("active")) return 1
      else if ($(".mt_nav").parent().hasClass("active")) return 2
      else return 3
    })()
    
    if (page === clicked) {
      $(document).scrollTop(0)
      e.stopPropagation()
    }
  })
})
