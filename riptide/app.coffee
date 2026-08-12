# noop.pw

App =
  init: ->
    @toggle_exp
    console.log "init success"

    filter_btn = document.getElementById 'filter_academic'

    filter_btn.addEventListener 'click', @toggle_exp

  toggle_exp: ->
    exp_root = document.getElementById 'section_xp'
    if exp_root.className == 'xp'
      exp_root.className = "xp pro"
    else
      exp_root.className = "xp"


module.exports = App
