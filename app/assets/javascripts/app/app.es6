window.app = {
  defaultIsImgOpened: false,
  pageType: 1,
  users: [],
  firewoods: [],
  infos: [],
  infosVisible: true,

  foldImageAll: () => {
    app.defaultIsImgOpened = false
    app.render()
  },

  unfoldImageAll: () => {
    app.defaultIsImgOpened = true
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
      .html("서버와의 접속이 끊어졌습니다. <a href='/' class='reconnect'>여기를 눌러서 새로고침 해주세요.</a>")
      .slideDown()
    $title.html("새로고침 해주세요.")
  },

  render: () => {
    ReactDOM.render(
      React.createElement(Informations, {
        infos: app.infos, infosVisible: app.infosVisible
      }),
      document.getElementById("infos-wrapper")
    )
    ReactDOM.render(
      React.createElement(Firewoods, {
        firewoods: app.firewoods,
        defaultIsImgOpened: app.defaultIsImgOpened,
        originTitle: app.originTitle
      }),
      document.getElementById("firewoods-react")
    )

    let formProps = {}
    if (localStorage) {
      const cache = localStorage.getItem("form_cache")
      if (cache) {
        formProps = JSON.parse(cache)
      }
    }
    formProps.originTitle = app.originTitle
    ReactDOM.render(
      React.createElement(FirewoodForm, formProps),
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
  const fws = app.firewoods
  if (fws.length < 50) { return false }
  if (app.channel.logGetLock) { return false }

  const lastIdx = fws.length - 1
  if (fws[lastIdx].id < 10) { return false }
  const $bottomTarget = $(`.firewood[data-id=${fws[lastIdx].id}]`)
  if ($bottomTarget.length === 0) { return false }
  if (!$bottomTarget.isOnScreen()) { return false }
  app.channel.getLogs(app.pageType)
}

$(() => {
  "use strict"
  if (document.getElementById("firewoods") === null) { return }

  new app.AppView({}, {})

  app.channel = new app.Channel()
  app.channel.load(app.pageType)
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
