var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodsView = Backbone.View.extend({
    el: '#firewoods',
    $list: $('#timeline'),
    $stack: $('#timeline_stack'),
    $form: $('#new_firewood'),
    count: 0,
    maxCount: 150,

    initialize: function () {
      this.listenTo(app.firewoods, 'reset', this.addAll);
      this.listenTo(app.firewoods, 'add:prepend', this.prepend);
      this.listenTo(app.firewoods, 'add:append', this.append);
      this.listenTo(app.BWClient, 'ajaxSuccess', this.formClear);
      this.$form.submit(this.submit);

      $('span[rel=tooltip]').tooltip();
      
      // $('#firewood_contents').bind('input keyup paste', this.update_count);
    },

    events: {
      'input #firewood_contents': 'update_count',
      'keyup #firewood_contents': 'update_count',
      'paste #firewood_contents': 'update_count'
    },

    // Collection Event
    addAll: function () {
      this.$list.html('');
      app.firewoods.each(function (fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$list.append(view.render().el);
      }, this);
    },

    prepend: function () {
      var fws = app.firewoods.where({ state: -1 });
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$list.prepend(view.render().el);
        fw.set('state', 0);
      }, this);
    },

    append: function () {
      var fws = app.firewoods.where({ state: 1 });
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.append(view.render().el);
        fw.set('state', 0);
      }, this);
    },

    // DOM Event
    submit: function () {
      $(this).ajaxSubmit(app.BWClient.ajaxBasicOptions);
      return false;
    },

    formClear: function() {
      $('#new_firewood').clearForm();
      $('#img').val('');
      $('.fileinput-preview').html('');
      $('.fileinput')
        .removeClass('fileinput-exists')
        .addClass('fileinput-new');
      $('.fileinput-filename').html('');
      $('#commit').button('reset');
      $('#firewood_prev_mt').val('');

      this.update_count();
    },

    update_count: function () {
      var $input = $('#firewood_contents');
      var before = this.count;
      var now = this.maxCount - $input.val().length;

      if ( app.FirewoodsView.isFormEmpty() ) {
        $('#commit').val('Refresh');
      } else {
        $('#commit').val('Submit');
      }

      if ( now < 0 ) {
        var str = $input.val();
        $input.val(str.substr(0, this.maxCount));
        now = 0;
      }

      if ( before != now ) {
        this.count = now;
        $('#remaining_count').text(now);
      }
    }
  });
  
  app.FirewoodsView.isFormEmpty = function () {
    if ( $('div.fileinput-exists').length == 0 ) {
      var str = $('#firewood_contents').val();
      if ( str.length == 0 || str.search(/^\s+$/) != -1 ) {
        return true;
      }
    }
    return false;
  };
})(jQuery);