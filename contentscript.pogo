links = $('a').get()

$.get(chrome.extension.getURL("popup.html")) @(html)
  $ 'body'.append(html)

  inner container  = $ '.genie-container'
  input            = inner container.find 'input'
  wishes container = inner container.find '.genie-wishes'

  show (links) =
    wishes container.find '.genie-wish'.remove()

    for each @(link) in (links.slice 0 4)
      wish = $('<div class="genie-wish">')
      wish.text(link.inner text || link.href)
      wish.data('href', link.href)
      wishes container.append(wish)

    wishes container.find '.genie-wish'.first().add class 'focused'

  follow link () =
    current link = wishes container.find '.genie-wish.focused'.first()
    if (current link)
      window.location.href = current link.data 'href'

  $(document).on 'keydown' @(event)
    if (!inner container.has class 'visible')
      if (event.key code == 32 && event.'ctrlKey')
        inner container.add class 'visible'
        inner container.find 'input'.focus()
        event.preventDefault()
    else
      if (event.key code == 13)
        follow link()
      else if (event.key code == 27)
        inner container.remove class 'visible'

  $(document).on 'keyup' @(event)
    if (inner container.has class 'visible')
      current input value = input.val()
      selected links = [l, where: l <- links, @new RegExp(current input value, 'i').test(l.innerText || l.href)]
      show (selected links)

  $(document).on 'mouseover' '#uxLampContainer .genie-wish' @(event)
    inner container.find '.genie-wish'.remove class 'focused'
    $(this).add class 'focused'
    event.preventDefault()

  $(document).on 'click' '#uxLampContainer .genie-wish'
    follow link()
