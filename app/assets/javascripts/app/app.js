var app = app || {};
var ENTER_KEY = 13;
var FW_STATE = {IN_STACK: -1, IN_TL: 0, IN_LOG: 1};

// to avoid conflict with that of erb
_.templateSettings = {
  evaluate    : /\{\{([\s\S]+?)\}\}/g,
  interpolate : /\{\{=([\s\S]+?)\}\}/g,
  escape      : /\{\{-([\s\S]+?)\}\}/g
};

$(function () {
  'use strict';

  new app.AppView();
  new app.FirewoodsView();
  new app.UsersView();
  app.BWClient.load();
  app.BWClient.pullingTimer = setTimeout(app.BWClient.pulling, app.BWClient.pullingPeriod);
  setInterval(app.BWClient.getLogs, 1000);
});
