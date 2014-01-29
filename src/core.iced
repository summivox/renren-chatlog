###
 *!core
###

core = {}

# INJECTED: get one page of chatlog
# callback: (err, cleanEntries, hasMorePages) -> ...
do ->
  f = core.getChatPage = (uid, page, cb) ->
    # cleanup received chatlog entry
    cleanupEntry = (entry) ->
      try
        timeStr: entry.time
        #time: new Date entry.time
        id: entry.messageid
        name: entry.name
        #photo: JSON.parse(entry.info).head
        content: JSON.parse(entry.content).content
      catch e
        null

    new XN.net.xmlhttp # on-page xmlhttp wrapper for correct session handling
      url: "http://chatlist.renren.com/message/get"
      method: "post"
      data: util.encodeFormData {
        sessionId: uid
        isgroupchat: '0'
        page
      }
      onSuccess: (r) ->
        try
          o = JSON.parse r.responseText
          cleanEntries = o.chatlist.map cleanupEntry
          hasMorePages = (o.code == 0)
          cb? null, cleanEntries, hasMorePages
        catch e
          cb? e
      onError: (r) ->
        cb? r
  f.inject = (autocb) ->
    await window.kisume.set 'core', ['util'], {getChatPage: f}, defer()

# get all pages of chatlog
# callback: (err, cleanEntries) -> ...
core.getChatAll = (uid, cb) ->
  page = 1
  hasMorePages = true
  parts = []
  while hasMorePages
    await window.kisume.runAsync 'core', 'getChatPage',
      uid, page, defer(err, cleanEntries, hasMorePages)
    if err? then return cb? err
    parts.push cleanEntries
    page++
  cb? null, util.flatten parts.reverse()

core.init = (autocb) ->
  await core.getChatPage.inject defer()
