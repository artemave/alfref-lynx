// all links without duplucates
links = $ 'a'.get().reduce @(acc, link)
  same links = $.grep (acc) @(l)
    if (link.inner text)
      l.inner text == link.inner text
    else
      l.href == link.href

  if (same links.length == 0)
    acc.push (link)

  acc
[]

$.get(chrome.extension.getURL("popup.html")) @(html)
  $ 'body'.append(html)

  inner container  = $ '.genie-container'
  input            = inner container.find 'input'
  wishes container = inner container.find '.genie-wishes'

  show (links) =
    wishes container.find '.genie-wish'.remove()

    for each @(link) in (links.slice 0 6)
      wish = $('<div class="genie-wish">')
      wish.text(link.inner text || link.href)
      wish.data('href', link.href)
      wishes container.append(wish)

    wishes container.find '.genie-wish'.first().add class 'focused'

  follow link () =
    link = current link()
    if (link)
      window.location.href = link.data 'href'

  current link () =
    wishes container.find '.genie-wish.focused'.first()

  first link () =
    wishes container.find '.genie-wish'.first()

  last link () =
    wishes container.find '.genie-wish'.last()

  focus link (link) =
    inner container.find '.genie-wish'.remove class 'focused'
    link.add class 'focused'

  close popup () =
    inner container.remove class 'visible'

  $(document).on 'keydown' @(event)
    if (!inner container.has class 'visible')
      if (event.key code == 32 && event.'ctrlKey')
        inner container.add class 'visible'
        inner container.find 'input'.focus().get(0).select()
        event.preventDefault()
    else
      if (event.key code == 13)
        close popup()
        follow link()
      else if (event.key code == 40)
        next link = current link().next()
        next link := if (next link.length > 0) @{ next link } else @{ first link() }
        focus link (next link)
        event.preventDefault()
      else if (event.key code == 38)
        prev link = current link().prev()
        prev link := if (prev link.length > 0) @{ prev link } else @{ last link() }
        focus link (prev link)
        event.preventDefault()
      else if (event.key code == 27)
        close popup()

  $(document).on 'keyup' '#uxLampContainer input' @(event)
    if ($.inArray(event.key code, [13,40,38,27]) == -1)
      current input value = input.val()
      selected links = [l, where: l <- links, @new RegExp(current input value, 'i').test(l.innerText || l.href)]
      show (selected links)

  $(document).on 'mouseover' '#uxLampContainer .genie-wish' @(event)
    focus link($(this))
    event.preventDefault()

  $(document).on 'click' '#uxLampContainer .genie-wish' @(event)
    follow link()
    event.preventDefault()
