var app = app || {};

$(function () {
  'use strict';

  // to avoid conflict with that of erb
  _.templateSettings = {
    evaluate    : /\{\{(.+?)\}\}/g,
    interpolate : /\{\{=(.+?)\}\}/g,
    escape      : /\{\{-(.+?)\}\}/g
  };
});
