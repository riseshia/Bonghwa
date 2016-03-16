var autoLink,
  slice = [].slice;

autoLink = function() {
  var callback, callbackOption, key, link_attributes, option, options, url_pattern, value;
  options = 1 <= arguments.length ? slice.call(arguments, 0) : [];
  url_pattern = /(^|\s)(https?\:\/\/\S+(\.[^\s\<]+))/gi;
  if (options.length > 0) {
    option = options[0];
    callbackOption = option.callback;
    if ((callbackOption != null) && typeof callbackOption === 'function') {
      callback = callbackOption;
      delete option.callback;
    }
    link_attributes = '';
    for (key in option) {
      value = option[key];
      link_attributes += " " + key + "='" + value + "'";
    }
    return this.replace(url_pattern, function(match, space, url) {
      var link, returnCallback, short_url;
      returnCallback = callback && callback(url);
      short_url = url;
      if (url.length > 20) {
        short_url = short_url.substring(0, 20);
        short_url += "...";
      }
      link = returnCallback || ("<a class='link_url' href='" + url + "'" + link_attributes + ">" + short_url + "</a>");
      return "" + space + link;
    });
  } else {
    return this.replace(url_pattern, "$1<a href='$2'>$2</a>");
  }
};

String.prototype['autoLink'] = autoLink;