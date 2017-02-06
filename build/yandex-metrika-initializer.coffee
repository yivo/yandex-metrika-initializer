###!
# yandex-metrika-initializer 1.0.6 | https://github.com/yivo/yandex-metrika-initializer | MIT License
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
  hiturl       = -> location.href.split('#')[0]
  hitoptions   = -> title: document.title, referrer: document.referrer
  
  window.yandex_metrika_callbacks = [init, hit]

  if Turbolinks?.supported
    $document  = $(document)
    hitoptions = -> title: document.title, referrer: Turbolinks.referrer
    $document.one 'page:change', -> $document.on('page:change', hit)

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
