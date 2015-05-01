var app = app || {};
var ENTER_KEY = 13;
var ESC_KEY = 27;
var FW_STATE = {IN_STACK: -1, IN_TL: 0, IN_LOG: 1};
var PAGE_TYPE = 1;

// to avoid conflict with that of erb
_.templateSettings = {
  evaluate    : /\{\{([\s\S]+?)\}\}/g,
  interpolate : /\{\{=([\s\S]+?)\}\}/g,
  escape      : /\{\{-([\s\S]+?)\}\}/g
};

$(function () {
  'use strict';

  app.channel = new app.Channel(app.firewoods, app.users);
  new app.AppView();
  new app.FirewoodsView();
  new app.UsersView();
  Backbone.history.start();
});
