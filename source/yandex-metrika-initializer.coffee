###!
# yandex-metrika-initializer 1.0.7 | https://github.com/yivo/yandex-metrika-initializer | MIT License
###

initialize = (counterID, options) ->
  unless counterID
    throw new TypeError('[Yandex Metrika Initializer] Counter ID is required')

  script       = document.createElement('script')
  script.type  = 'text/javascript'
  script.async = true
  script.src   = 'https://mc.yandex.ru/metrika/watch.js'
  metrika      = null
  append       = -> document.getElementsByTagName('head')[0].appendChild(script)
  # https://yandex.ru/support/metrika/code/ajax-flash.xml
  init         = -> metrika = new Ya.Metrika($.extend(id: counterID, options, defer: true))
  hit          = -> metrika.hit(hiturl(), hitoptions())
  hitwith      = (url, options) -> -> metrika.hit(url, options)
  hiturl       = -> location.href.split('#')[0]
  hitoptions   = -> title: document.title, referrer: document.referrer

  #                                  Init metrika when JS will load.
  #                                  |     Enqueue hit with fixed url and options.
  #                                  |     |
  window.yandex_metrika_callbacks = [init, hitwith(hiturl(), hitoptions())]

  if Turbolinks?.supported
    $document  = $(document)
    hitoptions = -> title: document.title, referrer: Turbolinks.referrer
    $document.one 'page:change', ->
      $document.on 'page:change', ->
        if metrika?
          hit()
        # If user navigated to next page but metrika has not been loaded yet.
        else
          # Enqueue hit with fixed url and options.
          window.yandex_metrika_callbacks.push hitwith(hiturl(), hitoptions())

  if window.opera is '[object Opera]'
    document.addEventListener('DOMContentLoaded', append, false)
  else
    append()

if (head = document.getElementsByTagName('head')[0])?
  for el in head.getElementsByTagName('meta')
    switch el.getAttribute('name')
      when 'yandex_metrika:counter_id'
        counterID = el.getAttribute('content')
      when 'yandex_metrika:options'
        json = el.getAttribute('content')
        try options = JSON?.parse(json) ? $.parseJSON(json)

  initialize(counterID, options) if counterID
