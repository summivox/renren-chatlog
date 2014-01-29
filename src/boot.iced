###
 *!boot
###

if !unsafeWindow? then unsafeWindow = window

$ ->
  console.log '### renren-chatlog starting'

  # kisume
  await window.kisume = Kisume unsafeWindow, 'kisume_rrcl', {coffee: true}, defer()
  await window.kisume.set 'util', [], util, defer()

  await
    core.init defer()

  ui.init()

  console.log '### renren-chatlog ready'
