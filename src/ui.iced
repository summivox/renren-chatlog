###
 *!ui
###

ui = {}

do ->
  TAG = 'rrcl-done'
  SEL = ".chat-window:not(.friends-window):not(.#{TAG})"

  ui.error = (e) ->
    console.log 'renren-chatlog error:'
    console.error e
    alert """
      renren-chatlog: Error during export.
      See console for details.
    """

  ui.scan = ->
    for chatWindowEl in [].slice.call document.querySelectorAll SEL
      # get user id/name
      # FIXME: too dirty now (basically just HTML scrapping)
      profileLinkEl = chatWindowEl.querySelector("a[title*='主页']")
      if !profileLinkEl then continue
      uid = profileLinkEl.href.match(/renren\.com\/(\d+)/)[1]
      name = profileLinkEl.textContent

      if uid then do (chatWindowEl, uid, name) ->
        # find UI insertion point
        chatHistoryEl = chatWindowEl.querySelector '.wp-chat-history'

        # fix positioning
        chatHistoryEl.style.cssText = '''
          position: relative;
          float: right
        '''

        # insert ui
        uiEl = document.createElement 'span'
        uiEl.innerHTML = PACKED_HTML['ui.html']
        chatHistoryEl.parentElement.insertBefore uiEl, chatHistoryEl

        # actions
        for {ext, mime, postproc} in [
          {
            ext: 'json'
            mime: 'application/json'
            postproc: (x) -> JSON.stringify x
          }
          {
            ext: 'csv'
            mime: 'text/csv'
            postproc: (x) -> '\ufeff' + toCsv(x) # NOTE: add UTF-8 BOM
          }
        ]
          uiEl.querySelector(".rrcl-ui-#{ext}").addEventListener 'click', ->
            core.getChatAll uid, (err, cleanEntries) ->
              if err then return ui.error err
              try
                util.download postproc(cleanEntries),
                  mime, "renren-chatlog-#{uid}-#{name}.#{ext}"
              catch e
                ui.error err

        # mark as finished
        chatWindowEl.addClass TAG

    return #ui.scan

  ui.init = ->
    ui.iid = setInterval ->
      ui.scan()
    , 500
