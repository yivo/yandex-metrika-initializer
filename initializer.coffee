###!
# yandex-metrika-initializer 1.0.4 | https://github.com/yivo/yandex-metrika-initializer | MIT License
###
  
initialize = do ->
  initialized = false

  (counterID, options) ->
    unless initialized
      unless counterID
        throw new TypeError('[Yandex Metrika Initializer] Counter ID is required')

      metrika = null
      (window.yandex_metrika_callbacks ?= []).push ->
        try metrika = new Ya.Metrika($.extend(id: counterID, options, defer: true)); return
  
      script             = document.createElement('script')
      script.type        = 'text/javascript'
      script.async       = true
      script.src         = 'https://mc.yandex.ru/metrika/watch.js'
      append             = -> document.getElementsByTagName('head')[0]?.appendChild(script); return
      hit                = -> metrika?.hit?(location.href.split('#')[0], title: document.title); return

      if window.opera is '[object Opera]'
        document.addEventListener('DOMContentLoaded', append, false)
      else
        append()
  
      if Turbolinks?.supported
        $(document).on('page:change', hit)
      else
        hit()
        $(document).on('pjax:end', hit) if $.support.pjax

      initialized = true
    return

if (head = document.getElementsByTagName('head')[0])?
  for el in head.getElementsByTagName('meta')
    switch el.getAttribute('name')
      when 'yandex_metrika:counter_id'
        counterID = el.getAttribute('content')
      when 'yandex_metrika:options'
        json = el.getAttribute('content')
        try options = JSON?.parse(json) ? $.parseJSON(json)

  initialize(counterID, options) if counterID
