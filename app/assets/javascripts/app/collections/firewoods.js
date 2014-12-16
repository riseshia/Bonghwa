var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    prepend: function (fws, type) {
      this.add(fws);

      if ( type == -1 ) {
        this.trigger('add:stack');
      } else if ( type == 0 ) {
        this.trigger('add:prepend');
      }
    },

    append: function (fws) {
      this.add(fws);
      this.trigger('add:append');
    },

    getPreviousFws: function (fw, limit) {
      var prev_id = fw.get('prev_mt');
      var fws = [];
      var tmp = fw;
      if ( !this.findWhere({id: prev_id}) ) {
          // need ajax request
          return [];
      }

      while ( true ) {
        tmp = this.findWhere({id: prev_id});
        fws.push(tmp);
        prev_id = tmp.get('prev_mt');

        if (prev_id == 0 || fws.length == limit) {
          return fws;
        }
      }
    },

    highlightTag: function (tag) {
      this.each(function (fw) {
        fw.activeTag(tag);
      });
      this.trigger('activeTag', tag);
    },

    comparator: function(fw) {
      return -fw.get('id');
    }
  });

  app.firewoods = new Firewoods();
})();