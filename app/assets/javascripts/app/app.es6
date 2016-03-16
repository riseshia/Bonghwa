window.app = {}
window.ENTER_KEY = 13
window.ESC_KEY = 27
window.FW_STATE = {IN_STACK: -1, IN_TL: 0, IN_LOG: 1}
window.PAGE_TYPE = 1

// to avoid conflict with that of erb
_.templateSettings = {
  evaluate    : /\{\{([\s\S]+?)\}\}/g,
  interpolate : /\{\{=([\s\S]+?)\}\}/g,
  escape      : /\{\{-([\s\S]+?)\}\}/g
}

$(() => {
  'use strict'

  if ($('#firewoods').size() > 0) {
    app.channel = new app.Channel(app.firewoods, app.users)
    new app.AppView({}, { timeline_state: PAGE_TYPE })
    new app.FirewoodsView()
    new app.UsersView()
    Backbone.history.start()

    $('.all_nav').click((e) => {
      let page = window.PAGE_TYPE
      let clicked = (() => {
        if ($('.now_nav').parent().hasClass('active')) return 1
        else if ($('.mt_nav').parent().hasClass('active')) return 2
        else return 3
      })()
      
      if (page == clicked) {
        $(document).scrollTop(0)
        e.stopPropagation()
      }
    })
  }
})
