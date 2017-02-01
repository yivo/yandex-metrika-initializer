
/*!
 * yandex-metrika-initializer 1.0.5 | https://github.com/yivo/yandex-metrika-initializer | MIT License
 */

(function() {
  var counterID, el, head, i, initialize, json, len, options, ref, ref1;

  initialize = (function() {
    var initialized;
    initialized = false;
    return function(counterID, options) {
      var append, hit, init, metrika, script;
      if (!initialized) {
        if (!counterID) {
          throw new TypeError('[Yandex Metrika Initializer] Counter ID is required');
        }
        metrika = null;
        script = document.createElement('script');
        script.type = 'text/javascript';
        script.async = true;
        script.src = 'https://mc.yandex.ru/metrika/watch.js';
        append = function() {
          var ref;
          return (ref = document.getElementsByTagName('head')[0]) != null ? ref.appendChild(script) : void 0;
        };
        init = function() {
          return metrika = new Ya.Metrika($.extend({
            id: counterID
          }, options, {
            defer: true
          }));
        };
        hit = function() {
          return metrika.hit(location.href.split('#')[0], {
            title: document.title
          });
        };
        window.yandex_metrika_callbacks = [init, hit];
        if (typeof Turbolinks !== "undefined" && Turbolinks !== null ? Turbolinks.supported : void 0) {
          $(document).one('page:change', function() {
            return $(document).on('page:change', hit);
          });
        } else {
          if ($.support.pjax) {
            $(document).on('pjax:end', hit);
          }
        }
        if (window.opera === '[object Opera]') {
          document.addEventListener('DOMContentLoaded', append, false);
        } else {
          append();
        }
        initialized = true;
      }
    };
  })();

  if ((head = document.getElementsByTagName('head')[0]) != null) {
    ref = head.getElementsByTagName('meta');
    for (i = 0, len = ref.length; i < len; i++) {
      el = ref[i];
      switch (el.getAttribute('name')) {
        case 'yandex_metrika:counter_id':
          counterID = el.getAttribute('content');
          break;
        case 'yandex_metrika:options':
          json = el.getAttribute('content');
          try {
            options = (ref1 = typeof JSON !== "undefined" && JSON !== null ? JSON.parse(json) : void 0) != null ? ref1 : $.parseJSON(json);
          } catch (error) {}
      }
    }
    if (counterID) {
      initialize(counterID, options);
    }
  }

}).call(this);
