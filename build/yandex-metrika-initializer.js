
/*!
 * yandex-metrika-initializer 1.0.7 | https://github.com/yivo/yandex-metrika-initializer | MIT License
 */

(function() {
  var counterID, el, head, i, initialize, json, len, options, ref, ref1;

  initialize = function(counterID, options) {
    var $document, append, hit, hitoptions, hiturl, hitwith, init, metrika, script;
    if (!counterID) {
      throw new TypeError('[Yandex Metrika Initializer] Counter ID is required');
    }
    script = document.createElement('script');
    script.type = 'text/javascript';
    script.async = true;
    script.src = 'https://mc.yandex.ru/metrika/watch.js';
    metrika = null;
    append = function() {
      return document.getElementsByTagName('head')[0].appendChild(script);
    };
    init = function() {
      return metrika = new Ya.Metrika($.extend({
        id: counterID
      }, options, {
        defer: true
      }));
    };
    hit = function() {
      return metrika.hit(hiturl(), hitoptions());
    };
    hitwith = function(url, options) {
      return function() {
        return metrika.hit(url, options);
      };
    };
    hiturl = function() {
      return location.href.split('#')[0];
    };
    hitoptions = function() {
      return {
        title: document.title,
        referrer: document.referrer
      };
    };
    window.yandex_metrika_callbacks = [init, hitwith(hiturl(), hitoptions())];
    if (typeof Turbolinks !== "undefined" && Turbolinks !== null ? Turbolinks.supported : void 0) {
      $document = $(document);
      hitoptions = function() {
        return {
          title: document.title,
          referrer: Turbolinks.referrer
        };
      };
      $document.one('page:change', function() {
        return $document.on('page:change', function() {
          if (metrika != null) {
            return hit();
          } else {
            return window.yandex_metrika_callbacks.push(hitwith(hiturl(), hitoptions()));
          }
        });
      });
    }
    if (window.opera === '[object Opera]') {
      return document.addEventListener('DOMContentLoaded', append, false);
    } else {
      return append();
    }
  };

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
