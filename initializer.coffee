initialize = do ->
  initialized = no

  (counterID, options) ->
    return if initialized

    throw new Error('Yandex Metrika initializer: Counter ID is required') unless counterID

    initialized = yes
    metrika     = null
    
    (window.yandex_metrika_callbacks ?= []).push ->
      try metrika = new Ya.Metrika($.extend(id: counterID, options, defer: yes))

    script             = document.createElement('script')
    script.type        = 'text/javascript'
    script.async       = true
    script.src         = 'https://mc.yandex.ru/metrika/watch.js'
    script.crossOrigin = 'anonymous'
    append             = -> document.getElementsByTagName('head')[0]?.appendChild(script); return

    if window.opera is '[object Opera]'
      document.addEventListener('DOMContentLoaded', append, false)
    else append()

    hit = -> metrika?.hit?(location.href.split('#')[0], title: document.title); return

    if Turbolinks?
      if Turbolinks.supported
        $(document).on('page:change', hit)
      else
        hit()
    else
      hit()
      $(document).on('pjax:end', hit) if $.fn.pjax?

    return

if (head = document.getElementsByTagName('head')[0])?
  meta      = head.getElementsByTagName('meta')
  counterID = null
  options   = null

  for el in meta
    if el.getAttribute('name') is 'yandex_metrika:counter_id'
      counterID   = el.getAttribute('content')
    else if el.getAttribute('name') is 'yandex_metrika:options'
      json = el.getAttribute('content')
      try options = JSON?.parse(json) or $.parseJSON(json)

  initialize(counterID, options) if counterID
